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

final class VideosComponent: TableViewControllerComponent<Video> {
    required init(_ value: TableViewController) {
        super.init(value)
        value.title = "Videos"
        value.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onTrash))
        value.onViewWillAppear = { [weak self] _ in self?.subscribe() }
        value.onViewDidDisappear = { [weak self] _ in self?.unsubscribe() }
        register(TextCell.self)
    }

    private func subscribe() {
        subscribe(\AppState.sections) { [weak self] sections in
            self?.sections = sections
        }
    }

    override func render(_ item: Video, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.setText(item.title)
        return cell
    }

    override func tapped(_ item: Video, at indexPath: IndexPath, in tableView: UITableView) {
        if indexPath.section == 0 {
            store.dispatch(.videosAction(.tappedVideo(item)))
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc private func onTrash() {
        store.dispatch(.videosAction(.clearHistory))
    }
}

private extension AppState {
    var sections: [TableViewSection<Video>] {
        return [
            TableViewSection(title: "Videos", items: videosState.videos),
            TableViewSection(title: watchedVideos.isEmpty ? nil : "History", items: watchedVideos.items())
        ]
    }
}

private extension Array where Element == Video {
    func items() -> [Video] {
        return lazy.reversed().unique.map {
            let x = self.count($0)
            return lens(\Video.title)
                .set($0, "\($0.title) (\(x) time\(x > 1 ? "s" : ""))")
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
