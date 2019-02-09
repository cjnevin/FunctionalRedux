//
//  Component+Subscriptions.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Render

extension Component {
    func subscribe<U>(_ keyPath: KeyPath<AppState, U>, callback: @escaping (U) -> Void) {
        references.append(store.subscribe { state in
            callback(state[keyPath: keyPath])
        })
    }

    func unsubscribe() {
        let subscriptions = references.compactMap { $0 as? String }
        subscriptions.forEach(store.unsubscribe)
        debugPrint("Removed \(subscriptions.count) subscriptions for \(self)")
    }
}

extension Component: Deallocatable {
    public func deallocate() {
        unsubscribe()
    }
}
