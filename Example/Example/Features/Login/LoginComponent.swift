//
//  LoginComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Render
import UIKit

final class LoginComponent: ViewControllerComponent {
    private lazy var email = TextFieldComponent {
        $0.apply(style: Styles.field.email)
        $0.input(\.accountState.loginState.email)
        $0.setOnChange { .loginFormAction(.setEmail($0)) }
        $0.setOnReturn { [weak self] in self?.password.unbox.becomeFirstResponder() }
    }
    private lazy var password = TextFieldComponent {
        $0.apply(style: Styles.field.password)
        $0.input(\.accountState.loginState.password)
        $0.setOnChange { .loginFormAction(.setPassword($0)) }
        $0.setOnReturn { [weak self] in self?.submit.onTapEvent() }
    }
    private lazy var submit = ButtonComponent {
        $0.apply(style: Styles.button.submit)
        $0.isEnabled(\.accountState.loginState.canLogIn)
        $0.setOnTap { [weak self] in
            self?.stackView.resignFirstResponders()
            return .loginAction(LoginAction.logIn)
        }
    }
    private lazy var stackView: Component<UIStackView> = {
        let stack = Component(UIStackView())
        stack.apply(style: Styles.stack.vertical)
        stack.addSubview(email, constraints: .height(equalTo: 44))
        stack.addSubview(password, constraints: .height(equalTo: 44))
        stack.addSubview(submit, constraints: .height(equalTo: 60))
        return stack
    }()
    private lazy var loadingView = LoadingComponent()

    required init(_ value: ViewController) {
        super.init(value)
        value.title = "Login"
        value.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        value.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        value.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }

        apply(style: Styles.view.defaultBackground())
        view?.addSubview(stackView, constraints: .equalTopSafeArea(offset: 20) <> .equalHorizontalEdges(offset: 20))
        view?.addSubview(loadingView, constraints: .equalEdges())
    }

    private func subscribe() {
        subscribe(\.accountState.loggedInUser) { [weak self] user in
            if user != nil {
                self?.clearPasswordAndDismiss()
            }
        }
        subscribe(\.accountState.loginState.revealed) { [weak self] revealed in
            guard let image = UIImage(named: revealed ? "crossed-eye" : "eye") else {
                assertionFailure("Missing image")
                return
            }
            self?.password.apply(style: Styles.field.isSecure(!revealed))
            self?.password.setAccessory(image: image) {
                return .loginFormAction(.revealPassword(!revealed))
            }
        }
        subscribe(\.accountState.loginState.pending) { [weak self] loading in
            self?.loadingView.isLoading = loading
        }
        subscribe(\.accountState.loginState.failed) { [weak self] failed in
            guard failed else { return }
            self?.present(AlertComponent(alert: .loginFailed()))
        }
    }

    @objc private func onCancel() {
        clearPasswordAndDismiss()
    }

    private func clearPasswordAndDismiss() {
        stackView.resignFirstResponders()
        dismiss {
            store.dispatch(.loginFormAction(.setPassword(nil)))
        }
    }
}

// MARK: - Alert

private extension Alert {
    static func loginFailed() -> Alert {
        return Alert("Login Failed", message: "Something went wrong", style: .alert, buttons: [.ok({ })])
    }
}

private extension Alert.Button {
    static func ok(_ callback: @escaping () -> Void) -> Alert.Button {
        return .init("OK", style: .cancel, callback: callback)
    }
}
