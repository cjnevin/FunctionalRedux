//
//  Component+Subscriptions.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Render

protocol ReferenceHaving {
    var references: [Any] { get set }
}

private extension ReferenceHaving {
    func _unsubscribe() -> [Any] {
        return references.reduce(into: []) { result, reference in
            guard let token = reference as? AppStore.Token else {
                result.append(reference)
                return
            }
            store.unsubscribe(token)
        }
    }
}

// MARK: - Component

extension Component: ReferenceHaving { }
extension Component {
    func subscribe(_ callback: @escaping (AppState) -> Void) {
        references.append(store.subscribe { state in
            callback(state)
        })
    }

    func subscribe<U>(_ keyPath: KeyPath<AppState, U>, callback: @escaping (U) -> Void) {
        references.append(store.subscribe { state in
            callback(state[keyPath: keyPath])
        })
    }

    func unsubscribe() {
        let count = references.count
        references = _unsubscribe()
        debugPrint("Removed \(count - references.count) subscriptions for \(self)")
    }
}

extension Component: Deallocatable {
    public func deallocate() {
        unsubscribe()
    }
}

// MARK: - WeakComponent

extension WeakComponent: ReferenceHaving { }
extension WeakComponent {
    func subscribe(_ callback: @escaping (AppState) -> Void) {
        references.append(store.subscribe { state in
            callback(state)
        })
    }

    func subscribe<U>(_ keyPath: KeyPath<AppState, U>, callback: @escaping (U) -> Void) {
        references.append(store.subscribe { state in
            callback(state[keyPath: keyPath])
        })
    }

    func unsubscribe() {
        let count = references.count
        references = _unsubscribe()
        debugPrint("Removed \(count - references.count) subscriptions for \(self)")
    }
}

extension WeakComponent: Deallocatable {
    public func deallocate() {
        unsubscribe()
    }
}
