//
//  VideosState.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

struct VideoDownload: Codable {
    var video: Video
    var progress: Int

    var isComplete: Bool {
        return progress == 100
    }
}

enum VideosAction {
    case clearHistory
    case downloading(VideoDownload)
    case download(Video)
    case watch(VideoDownload)
    case retry
}

struct VideosState: Codable {
    var videos: [Video] = []
}

let videoReducer = Reducer<(VideosState, [Video], [VideoDownload]), VideosAction, AppEffect> { state, action in
    var (videoState, watched, downloaded) = state
    defer { state = (videoState, watched, downloaded) }

    switch action {
    case .clearHistory:
        watched = []
        downloaded = []
        return .log("Cleared history")
            <> .save
    case let .watch(download) where download.isComplete:
        watched += [download.video]
        return .log("Watched \(download.video.title)")
            <> .save
    case .watch:
        return .empty
    case let .download(video):
        return .log("Downloading \(video.title)")
            <> .save
            <> .download(video)
    case let .downloading(download):
        if let firstIndex = downloaded.firstIndex(where: { $0.video.id == download.video.id }) {
            downloaded[firstIndex] = download
        } else {
            downloaded.append(download)
        }
        return .log("Download progress: \(download.progress) for \(download.video.id)")
            <> .save
    case .retry:
        return downloaded
            .filter { !$0.isComplete }
            .map { $0.video }
            .map(AppEffect.download)
            .reduce(.empty, <>)
    }
}

// FAKE: Extension to fake a download
private extension AppEffect {
    static func download(_ video: Video) -> AppEffect {
        var initial = VideoDownload(video: video, progress: 0)

        func increments() -> [VideoDownload] {
            var copy = initial
            var values = [VideoDownload]()
            while copy.progress < 100 {
                copy.incrementProgress()
                values.append(copy)
                print(copy.progress)
            }
            return values
        }

        func action(_ video: VideoDownload) -> AppAction {
            return AppAction.videosAction(.downloading(video))
        }

        func effect(_ index: Int, action: AppAction) -> AppEffect {
            return AppEffect.delay(.action(action), TimeInterval(index + 1))
        }

        let incrementEffects = increments().lazy
            .map(action)
            .enumerated()
            .map(effect)
            .reduce(.empty, <>)

        return .action(.videosAction(.downloading(initial))) <> incrementEffects
    }
}

private extension VideoDownload {
    func incrementingProgress() -> VideoDownload {
        let total = 100
        let seed = arc4random_uniform(UInt32(total - progress)) + 1
        let newProgress = progress + min(total, Int(seed))
        return VideoDownload(video: video, progress: newProgress)
    }

    mutating func incrementProgress() {
        self = incrementingProgress()
    }
}

struct Video: Codable {
    var id: Int
    var title: String
    var videoUrl: String
}
