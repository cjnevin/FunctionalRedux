//
//  AccountState.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

struct Settings {
    var notificationsOn: Bool = false
}

enum AccountAction {
    case loggedIn(User)
    case loginFailed
    case tappedLogout
    case tappedNotification(on: Bool)
}

struct AccountState {
    var loginState: LoginState = .init()
    var loggedInUser: User? = nil
    var settings: Settings = .init()
}

let accountReducer = Reducer<AccountState, AccountAction, AppEffect> { state, action in
    switch action {
    case let .loggedIn(user):
        state.loggedInUser = user
        return .log("Logged in as \(user.name)")
    case .loginFailed:
        return .log("Log in failed")
    case .tappedLogout:
        state.loggedInUser = nil
    case let.tappedNotification(on):
        state.settings.notificationsOn = on
    }
    return .identity
}
