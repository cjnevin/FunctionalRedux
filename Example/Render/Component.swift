//
//  Component.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public protocol Deallocatable {
    func deallocate()
}

open class Component<T: AnyObject>: NSObject {
    private(set) public var unbox: T
    public var references: [Any] = []

    public required init(_ value: T) {
        self.unbox = value
    }

    deinit {
        (self as? Deallocatable)?.deallocate()
    }
}

open class WeakComponent<T: AnyObject>: NSObject {
    private(set) public weak var unbox: T?
    public var references: [Any] = []

    public required init(_ value: T) {
        self.unbox = value
    }

    deinit {
        (self as? Deallocatable)?.deallocate()
    }
}

extension Component {
    public func apply(style: Style<T>) {
        style.apply(to: unbox)
    }
}

extension WeakComponent {
    public func apply(style: Style<T>) {
        unbox.map(style.apply)
    }
}

extension WeakComponent where T: UIViewController {
    public var view: Component<UIView>? {
        return unbox.map { Component<UIView>($0.view) }
    }
}

extension Component {
    public func cast<U>() -> Component<U>? {
        return (unbox as? U).map(Component<U>.init)
    }
}
