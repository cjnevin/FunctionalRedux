//
//  LoginState.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

enum LoginFormAction {
    case revealPassword(Bool)
    case setEmail(String?)
    case setPassword(String?)
}

enum LoginAction {
    case logIn
    case loginFailed
    case loggedIn(User)
    case resetFailed
}

struct LoginState: Codable {
    enum CodingKeys: String, CodingKey {
        case email
    }
    var email: String?
    var password: String?
    var revealed: Bool = false
    var pending: Bool = false
    var failed: Bool = false
    var canLogIn: Bool { return fields.lazy.map { $0.isNotEmpty }.reduce(true, <>) }

    private var fields: [String?] {
        return [email, password]
    }
}

let loginFormReducer = Reducer<LoginState, LoginFormAction, AppEffect> { state, action in
    switch action {
    case let .setEmail(email):
        state.email = email
        return .log(email.map { "Set email to: \($0)" } ?? "Cleared email")
            <> .save
    case let .setPassword(password):
        state.password = password
        return .log(password.map { "Set password to: \($0)" } ?? "Cleared password")
            <> .save
    case let .revealPassword(revealed):
        state.revealed = revealed
        return .empty
    }
}

let loginReducer = Reducer<LoginState, LoginAction, AppEffect> { state, action in
    switch action {
    case .resetFailed:
        state.failed = false
        return .empty
    case .loginFailed:
        state.failed = true
        state.pending = false
        return .log("Log in failed")
            <> .async(.action(.loginAction(.resetFailed)))
    case .loggedIn:
        state.pending = false
        return .empty
    case .logIn:
        guard state.canLogIn, let email = state.email, let password = state.password else {
            return .empty
        }
        state.failed = false
        state.pending = true
        let effects: AppEffect = .log("Logging in") <> .track(.accountEvent(.logInPressed))
        // Hack to test both routes...
        if state.revealed == true {
            return effects <> .api(.logInFailureTest)
        } else {
            return effects <> .api(.logIn(email: email, password: password))
        }
    }
}

extension Result where E == ApiError, A == Data {
    func handleLogin() -> [AppAction] {
        return prism.success.preview(self)
            .flatMap(User.from)
            .map { [.loginAction(.loggedIn($0))] }
        ?? [.loginAction(.loginFailed)]
    }
}
