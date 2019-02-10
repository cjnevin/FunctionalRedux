//
//  AccountState.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

struct Settings: Codable {
    var notificationsOn: Bool = false
}

enum AccountAction {
    case loggedIn(User)
    case loginFailed
    case tappedLogout
    case tappedNotification(on: Bool)
}

struct AccountState: Codable {
    var loginState: LoginState = .init()
    var loggedInUser: User? = nil
    var settings: Settings = .init()
}
    
let accountReducer = Reducer<AccountState, AccountAction, AppEffect> { state, action in
    switch action {
    case let .loggedIn(user):
        state.loggedInUser = user
        return .log("Logged in as \(user.name)")
            <> .save
    case .loginFailed:
        return .log("Log in failed")
    case .tappedLogout:
        state.loggedInUser = nil
        return .log("Logged out")
            <> .save
    case let.tappedNotification(on):
        state.settings.notificationsOn = on
        return .save
    }
}

extension Result where E == ApiError, A == Data {
    func handleLogin() -> [AppAction] {
        guard case let .success(data) = self, let user = try? JSONDecoder().decode(User.self, from: data) else {
            return [.accountAction(.loginFailed)]
        }
        return [.accountAction(.loggedIn(user))]
    }
}
