//
//  LoginComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Render
import UIKit

final class LoginComponent: ViewControllerComponent {
    private lazy var email = TextFieldComponent {
        $0.apply(style: Styles.emailStyle)
        $0.input(\.accountState.loginState.email)
        $0.setOnChange { .loginAction(.setEmail($0)) }
        $0.setOnReturn { [weak self] in self?.password.unbox.becomeFirstResponder() }
    }
    private lazy var password = TextFieldComponent {
        $0.apply(style: Styles.passwordStyle)
        $0.input(\.accountState.loginState.password)
        $0.setOnChange { .loginAction(.setPassword($0)) }
        $0.setOnReturn { [weak self] in self?.submit.onTapEvent() }
    }
    private lazy var submit = ButtonComponent {
        $0.apply(style: Styles.submitStyle)
        $0.isEnabled(\.accountState.loginState.canLogIn)
        $0.setOnTap { [weak self] in
            self?.stackView.resignFirstResponders()
            return .loginAction(LoginAction.logIn)
        }
    }
    private lazy var stackView: Component<UIStackView> = {
        let stack = Component(UIStackView())
        stack.apply(style: Styles.verticalStackStyle)
        stack.addSubview(email, constraint: height(equalTo: 44))
        stack.addSubview(password, constraint: height(equalTo: 44))
        stack.addSubview(submit, constraint: height(equalTo: 60))
        return stack
    }()

    required init(_ value: ViewController) {
        super.init(value)
        apply(style: Styles.whiteViewStyle.promote())
        unbox?.title = "Login"
        unbox?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        view?.addSubview(stackView, constraints: [
            equalTopSafeArea(offset: 20),
            equalLeading(offset: 20),
            equalTrailing(offset: -20)])
        unbox?.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        unbox?.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }
    }

    private func subscribe() {
        subscribe(\.accountState.loggedInUser) { [weak self] user in
            if user != nil {
                self?.clearPasswordAndDismiss()
            }
        }
    }

    @objc private func onCancel() {
        clearPasswordAndDismiss()
    }

    private func clearPasswordAndDismiss() {
        stackView.resignFirstResponders()
        dismiss {
            store.dispatch(.loginAction(.setPassword(nil)))
        }
    }
}
