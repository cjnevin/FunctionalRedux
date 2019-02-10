//
//  ViewController.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

open class ViewController: UIViewController {
    private let componentType: WeakComponent<ViewController>.Type
    private var component: WeakComponent<ViewController>?
    open var onViewWillAppear: ((Bool) -> Void)?
    open var onViewWillDisappear: ((Bool) -> Void)?
    open var onViewDidAppear: ((Bool) -> Void)?
    open var onViewDidDisappear: ((Bool) -> Void)?

    public init(_ componentType: WeakComponent<ViewController>.Type) {
        self.componentType = componentType
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        component = componentType.init(self)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear?(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onViewWillDisappear?(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear?(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onViewDidDisappear?(animated)
    }
}

extension WeakComponent where T == ViewController {
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

extension WeakComponent where T: UIViewController {
    public func present<U: UIViewController>(_ component: WeakComponent<U>, animated: Bool = true) {
        component.unbox.map {
            self.unbox?.present($0, animated: animated, completion: nil)
        }
    }

    public func present<U: UIViewController>(_ component: Component<U>, animated: Bool = true) {
        unbox?.present(component.unbox, animated: animated, completion: nil)
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        unbox?.dismiss(animated: animated, completion: completion)
    }
}

extension WeakComponent where T: UIViewController {
    public func downcast() -> WeakComponent<UIViewController>? {
        return unbox.map(WeakComponent<UIViewController>.init)
    }
}

extension Component where T: UIViewController {
    public func downcast() -> Component<UIViewController> {
        return Component<UIViewController>(unbox)
    }
}

open class ViewControllerComponent: WeakComponent<ViewController> {

}
