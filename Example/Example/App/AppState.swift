//
//  AppState.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

enum AppAction {
    case accountAction(AccountAction)
    case loginAction(LoginAction)
    case loginFormAction(LoginFormAction)
    case videosAction(VideosAction)
}

struct AppState: Codable {
    var videosState: VideosState = .init()
    var accountState: AccountState = .init()
}

let appReducer = accountReducer
    .lift(state: lens(\AppState.accountState),
          action: AppAction.prism.accountAction)
    <> accountLoginReducer.lift(
        state: lens(\AppState.accountState),
        action: AppAction.prism.loginAction)
    <> loginReducer.lift(
        state: lens(\AppState.accountState.loginState),
        action: AppAction.prism.loginAction)
    <> loginFormReducer.lift(
        state: lens(\AppState.accountState.loginState),
        action: AppAction.prism.loginFormAction)
    <> videoReducer.lift(
        state: pair(lens(\.videosState), lens(\.accountState.settings.notificationsOn)),
        action: AppAction.prism.videosAction)

extension AppAction {
    enum prism {
        static let accountAction = Prism<AppAction, AccountAction>(
            preview: { if case let .accountAction(action) = $0 { return action } else { return nil } },
            review: AppAction.accountAction)

        static let loginAction = Prism<AppAction, LoginAction>(
            preview: { if case let .loginAction(action) = $0 { return action } else { return nil } },
            review: AppAction.loginAction)

        static let loginFormAction = Prism<AppAction, LoginFormAction>(
            preview: { if case let .loginFormAction(action) = $0 { return action } else { return nil } },
            review: AppAction.loginFormAction)

        static let videosAction = Prism<AppAction, VideosAction>(
            preview: { if case let .videosAction(action) = $0 { return action } else { return nil } },
            review: AppAction.videosAction)
    }
}
