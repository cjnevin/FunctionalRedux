//
//  Style.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

public struct Style<T> {
    private let callback: (T) -> Void

    public init(_ callback: @escaping (T) -> Void) {
        self.callback = callback
    }

    public func apply(to candidate: T) {
        callback(candidate)
    }
}

extension Style: Monoid {
    public static var empty: Style<T> {
        return .init { _ in }
    }
    
    public func combine(with other: Style) -> Style {
        return Style {
            self.callback($0)
            other.callback($0)
        }
    }
}
