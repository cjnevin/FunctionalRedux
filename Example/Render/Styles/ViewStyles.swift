//
//  ViewStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public enum view: ViewStyles { }
}

public protocol ViewConvertible {
    var uiView: UIView { get }
}

extension UIView: ViewConvertible {
    public var uiView: UIView {
        return self
    }
}

extension UIViewController: ViewConvertible {
    public var uiView: UIView {
        return view
    }
}

public protocol ViewStyles: LayerStyles { }

extension ViewStyles {
    public static func background<T: ViewConvertible>(_ color: UIColor) -> Style<T> {
        return .init { $0.uiView.backgroundColor = color }
    }
}
