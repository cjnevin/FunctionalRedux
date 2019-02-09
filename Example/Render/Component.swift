//
//  Component.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

open class Component<T: AnyObject>: NSObject {
    private(set) public var unbox: T

    public required init(_ value: T) {
        self.unbox = value
    }
}

extension Component {
    public func apply(style: Style<T>) {
        style.apply(to: unbox)
    }
}

extension Component where T: UIViewController {
    public var view: Component<UIView> {
        return Component<UIView>(unbox.view!)
    }
}

extension Component {
    public func cast<U>() -> Component<U>? {
        return (unbox as? U).map(Component<U>.init)
    }
}
