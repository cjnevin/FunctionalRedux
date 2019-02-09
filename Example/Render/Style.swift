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

extension Style: Semigroup {
    public func combine(with other: Style) -> Style {
        return Style {
            self.callback($0)
            other.callback($0)
        }
    }
}

extension Style where T == UIView {
    public func promote<U: UIViewController>() -> Style<U> {
        return Style<U> {
            $0.view.map(self.apply)
        }
    }

    public func promote<U: UIWindow>() -> Style<U> {
        return Style<U> {
            self.apply(to: $0)
        }
    }
}
