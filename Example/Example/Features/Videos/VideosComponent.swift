//
//  VideosComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Render
import UIKit

final class VideosCell: TextCell {
    func setItem(_ item: VideoItem) {
        setText(item.title)
        textLabel?.textColor = item.isReady ? .black : .lightGray
        textLabel?.font = item.isReady ? UIFont.systemFont(ofSize: 16) : UIFont.italicSystemFont(ofSize: 16)
        selectionStyle = item.isReady ? .default : .none
    }
}

final class VideosComponent: TableViewControllerComponent<VideoItem> {
    required init(_ value: TableViewController) {
        super.init(value)
        value.title = "Videos"
        value.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onTrash))
        value.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        value.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }
        register(VideosCell.self)
    }

    private func subscribe() {
        subscribe(\AppState.sections) { [weak self] sections in
            self?.sections = sections
        }
    }

    override func render(_ item: VideoItem, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(VideosCell.self, for: indexPath)
        cell.setItem(item)
        return cell
    }

    override func tapped(_ item: VideoItem, at indexPath: IndexPath, in tableView: UITableView) {
        switch item {
        case .video(let video):
            store.dispatch(.videosAction(.download(video)))
        case .download(let download):
            store.dispatch(.videosAction(.watch(download)))
        case .watched:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc private func onTrash() {
        store.dispatch(.videosAction(.clearHistory))
    }
}

enum VideoItem {
    case video(Video)
    case download(VideoDownload)
    case watched(String)

    var isReady: Bool {
        if case .download(let download) = self {
            return download.isComplete
        }
        return true
    }

    var title: String {
        switch self {
        case .video(let video): return video.title
        case .download(let download): return download.video.title + (download.isComplete ? "" : " \(download.progress)%")
        case .watched(let text): return text
        }
    }
}

private extension AppState {
    var sections: [TableViewSection<VideoItem>] {
        return [
            TableViewSection(title: "Available", items: videosState.videos.map(VideoItem.video)),
            TableViewSection(title: downloadedVideos.isEmpty ? nil : "Downloads", items: downloadedVideos.map(VideoItem.download)),
            TableViewSection(title: watchedVideos.isEmpty ? nil : "Watched", items: watchedVideos.items())
        ]
    }
}

private extension Array where Element == Video {
    func items() -> [VideoItem] {
        return lazy.reversed().unique.map {
            let x = self.count($0)
            return .watched(lens(\Video.title).set($0, "\($0.title) (\(x) time\(x > 1 ? "s" : ""))").title)
        }
    }

    private func count(_ video: Video) -> Int {
        return filter { $0.id == video.id }.count
    }

    private var unique: [Video] {
        return reduce(into: [], { (result, video) in
            if !result.contains { $0.id == video.id } {
                result.append(video)
            }
        })
    }
}
