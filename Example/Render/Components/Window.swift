//
//  WindowComponent.swift
//  Render
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class WindowComponent: Component<UIWindow> {
    public var root: Component<UIViewController>? {
        didSet { root.map(setRoot) }
    }

    public convenience init() {
        self.init(UIWindow(frame: UIScreen.main.bounds))
    }

    func setRoot<T: UIViewController>(_ component: Component<T>) {
        unbox.rootViewController = component.unbox
        if !unbox.isKeyWindow {
            unbox.makeKeyAndVisible()
        }
    }
}
