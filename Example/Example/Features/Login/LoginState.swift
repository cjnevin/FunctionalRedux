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

enum LoginAction {
    case setEmail(String?)
    case setPassword(String?)
    case logIn
}

struct LoginState {
    var email: String?
    var password: String?
    var canLogIn: Bool { return fields.lazy.map { $0.isNotEmpty }.reduce(true, <>) }

    private var fields: [String?] {
        return [email, password]
    }
}

let loginReducer = Reducer<LoginState, LoginAction, AppEffect> { state, action in
    switch action {
    case let .setEmail(email):
        state.email = email
        return .log(email.map { "Set email to: \($0)" } ?? "Cleared email")
    case let .setPassword(password):
        state.password = password
        return .log(password.map { "Set password to: \($0)" } ?? "Cleared password")
    case .logIn:
        guard state.canLogIn, let email = state.email, let password = state.password else {
            return .identity
        }
        return .log("Logging in")
            <> .track(.accountEvent(.logInPressed))
            <> .api(.logIn(email: email, password: password))
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
