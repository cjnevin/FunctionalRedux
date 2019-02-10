//
//  VideosState.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

struct Video: Codable {
    let id: Int
    let title: String
    let videoUrl: String
}

enum VideosAction {
    case clearHistory
    case tappedVideo(Video)
}

struct VideosState: Codable {
    var videos: [Video] = []
}

let videoReducer = Reducer<(VideosState, [Video]), VideosAction, AppEffect> { state, action in
    var (videoState, watchedVideos) = state
    defer { state = (videoState, watchedVideos) }

    switch action {
    case .clearHistory:
        watchedVideos = []
        return .log("Cleared history")
            <> .save
    case let .tappedVideo(video):
        watchedVideos += [video]
        return .log("Watched \(video.title)")
            <> .save
    }
}
