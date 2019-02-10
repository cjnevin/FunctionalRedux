//
//  AccountComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class AccountComponent: TableViewControllerComponent<AccountItem> {
    required init(_ value: TableViewController) {
        super.init(value)
        value.title = "Account"
        value.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        value.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }
        register(SwitchCell.self)
        register(TextCell.self)
    }

    private func subscribe() {
        subscribe(\.accountState.sections) { [weak self] sections in
            self?.sections = sections
        }
    }

    override func render(_ item: AccountItem, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch item {
        case .login, .logout, .user:
            let cell = tableView.dequeue(TextCell.self, for: indexPath)
            cell.setText(item.title)
            return cell
        case .notifications(let on):
            let cell = tableView.dequeue(SwitchCell.self, for: indexPath)
            cell.setText(item.title)
            cell.setOn(on)
            cell.setOnToggle { on in
                return .accountAction(.tappedNotification(on: on))
            }
            return cell
        }
    }

    override func tapped(_ item: AccountItem, at indexPath: IndexPath, in tableView: UITableView) {
        func deselect() {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch item {
        case .login:
            present(LoginComponent.navigationComponent())
        case .logout:
            present(AlertComponent(alert: .logout(cancel: deselect) {
                store.dispatch(.accountAction(.tappedLogout))
            }))
        case .notifications(let on):
            store.dispatch(.accountAction(.tappedNotification(on: !on)))
        case .user:
            deselect()
        }
    }
}

// MARK: - Items

enum AccountItem {
    case login
    case logout
    case user(User)
    case notifications(Bool)

    fileprivate var title: String {
        switch self {
        case .login: return "Login"
        case .logout: return "Logout"
        case .notifications: return "Receive Notifications"
        case .user(let user): return user.name
        }
    }
}

private extension AccountState {
    var sections: [TableViewSection<AccountItem>] {
        let user = loggedInUser.map { [AccountItem.user($0), .logout] } ?? [.login]
        let all = user + [.notifications(settings.notificationsOn)]
        return [TableViewSection(title: nil, items: all)]
    }
}

// MARK: - Alert

private extension Alert {
    static func logout(cancel: @escaping () -> Void, logout: @escaping () -> Void) -> Alert {
        return Alert("Logout?", message: "Are you sure?", style: .alert, buttons: [.cancel(cancel), .logout(logout)])
    }
}

private extension Alert.Button {
    static func cancel(_ callback: @escaping () -> Void) -> Alert.Button {
        return .init("Cancel", style: .cancel, callback: callback)
    }
    static func logout(_ callback: @escaping () -> Void) -> Alert.Button {
        return .init("Logout", style: .default, callback: callback)
    }
}
