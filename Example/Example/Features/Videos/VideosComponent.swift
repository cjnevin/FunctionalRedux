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

final class VideosComponent: TableViewControllerComponent<VideoItem> {
    required init(_ value: TableViewController) {
        super.init(value)
        Styles.table.view.apply(to: value.tableView)
        value.title = "Videos"
        value.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onTrash))
        value.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        value.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }
        register(VideosCell.self)
        store.dispatch(.videosAction(.retry))
    }

    private func subscribe() {
        subscribe(\AppState.videosState.sections) { [weak self] sections in
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

final class VideosCell: TableViewCell {
    func setItem(_ item: VideoItem) {
        item.titleStyle.apply(to: self)
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

    private var _title: String {
        switch self {
        case .video(let video): return video.title
        case .download(let download): return download.video.title + (download.isComplete ? "" : " \(download.progress)%")
        case .watched(let text): return text
        }
    }

    var titleStyle: Style<VideosCell> {
        return Styles.table.cell.style(_title, isEnabled: isReady)
    }
}

private extension VideosState {
    var sections: [TableViewSection<VideoItem>] {
        return [
            TableViewSection(title: "Available", items: available.map(VideoItem.video)),
            TableViewSection(title: downloaded.isEmpty ? nil : "Downloads", items: downloaded.map(VideoItem.download)),
            TableViewSection(title: watched.isEmpty ? nil : "Watched", items: watched.items())
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
