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
    case videosAction(VideosAction)
}

struct AppState: Codable {
    var videosState: VideosState = .init()
    var accountState: AccountState = .init()
    var watchedVideos: [Video] = []
}

let appReducer: Reducer<AppState, AppAction, AppEffect> =
    accountReducer
        .lift(state: lens(\AppState.accountState),
              action: AppAction.prism.accountAction)
        <> loginReducer
            .lift(state: lens(\AppState.accountState.loginState),
                  action: AppAction.prism.loginAction)
        <> videoReducer
            .lift(state: both(lens(\.videosState), lens(\.watchedVideos)),
                  action: AppAction.prism.videosAction)

extension AppAction {
    enum prism {
        static let accountAction = Prism<AppAction, AccountAction>(
            preview: {
                if case let .accountAction(action) = $0 { return action }
                return nil
        }, review: AppAction.accountAction)

        static let loginAction = Prism<AppAction, LoginAction>(
            preview: {
                if case let .loginAction(action) = $0 { return action }
                return nil
        }, review: AppAction.loginAction)

        static let videosAction = Prism<AppAction, VideosAction>(
            preview: {
                if case let .videosAction(action) = $0 { return action }
                return nil
        }, review: AppAction.videosAction)
    }
}
