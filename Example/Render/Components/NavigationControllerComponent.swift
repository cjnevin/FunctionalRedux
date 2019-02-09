//
//  NavigationComponent.swift
//  Render
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class NavigationControllerComponent: Component<UINavigationController> {
    
}

extension Component where T: UINavigationController {
    public func push<U: UIViewController>(_ component: Component<U>, animated: Bool = true) {
        unbox.pushViewController(component.unbox, animated: animated)
    }

    public func pop(animated: Bool = true) {
        unbox.popViewController(animated: animated)
    }

    public func popToRoot(animated: Bool = true) {
        unbox.popToRootViewController(animated: animated)
    }
}
