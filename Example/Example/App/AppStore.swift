//
//  AppStore.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Core

let store = AppStore(
    reducer: appReducer,
    initialState: dependencies.store.get() ?? getDefaultState(),
    interpreter: appInterpreter(dependencies)
)

typealias AppStore = Store<AppState, AppAction, AppEffect>

private let dependencies = Dependencies()

private func getDefaultState() -> AppState {
    let video1 = Video(id: 1, title: "The Matrix", videoUrl: "matrix.mp4")
    let video2 = Video(id: 2, title: "The Matrix Reloaded", videoUrl: "matrix2.mp4")
    let video3 = Video(id: 3, title: "The Matrix Revolutions", videoUrl: "matrix3.mp4")
    return .init(
        videosState: VideosState(
            videos: [video1, video2, video3]
        ),
        accountState: AccountState(
            loginState: .init(email: nil,
                              password: nil,
                              revealed: false,
                              pending: false,
                              failed: false),
            loggedInUser: nil,
            settings: .init(notificationsOn: false)
        ),
        watchedVideos: [],
        downloadedVideos: []
    )
}
