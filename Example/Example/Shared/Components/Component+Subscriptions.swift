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
        references.compactMap { $0 as? String }.forEach(store.unsubscribe)
        debugPrint("Unsubscribe \(self)")
    }
}

extension Component: Deallocatable {
    public func deallocate() {
        unsubscribe()
    }
}
