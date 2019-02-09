//
//  TabBarComponent.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class TabBarControllerComponent: Component<UITabBarController> {
    private(set) public var components: [Component<UIViewController>] = []

    public convenience init(_ components: [Component<UIViewController>]) {
        self.init(UITabBarController(nibName: nil, bundle: nil))
        setComponents(components)
    }

    public func setComponents(_ components: [Component<UIViewController>], animated: Bool = false) {
        self.components = components
        unbox.setViewControllers(components.map { $0.unbox }, animated: animated)
    }
}
