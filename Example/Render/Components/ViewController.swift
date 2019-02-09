//
//  ViewController.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class ViewController: UIViewController {
    private let componentType: Component<ViewController>.Type
    private var component: Component<ViewController>!

    public init(_ componentType: Component<ViewController>.Type) {
        self.componentType = componentType
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        component = componentType.init(self)
    }
}

extension Component where T == ViewController {
    public static func viewController() -> ViewController {
        return ViewController(self)
    }

    public static func navigationController() -> UINavigationController {
        return UINavigationController(rootViewController: viewController())
    }

    public static func navigationComponent() -> NavigationControllerComponent {
        return NavigationControllerComponent(navigationController())
    }
}

extension Component where T: UIViewController {
    public func present<U: UIViewController>(_ component: Component<U>, animated: Bool = true) {
        unbox.present(component.unbox, animated: animated, completion: nil)
    }

    public func dismiss(animated: Bool = true) {
        unbox.dismiss(animated: animated, completion: nil)
    }
}

extension Component where T: UIViewController {
    public func downcast() -> Component<UIViewController> {
        return Component<UIViewController>(unbox)
    }
}
