//
//  Layer.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public enum layer: LayerStyles { }
}

public protocol LayerConvertible {
    var caLayer: CALayer { get }
}

extension CALayer: LayerConvertible {
    public var caLayer: CALayer {
        return self
    }
}

extension UIView: LayerConvertible {
    public var caLayer: CALayer {
        return layer
    }
}

public protocol LayerStyles { }

extension LayerStyles {
    public static func border<T: LayerConvertible>(width: CGFloat) -> Style<T> {
        return .init { $0.caLayer.borderWidth = width }
    }

    public static func border<T: LayerConvertible>(color: UIColor) -> Style<T> {
        return .init { $0.caLayer.borderColor = color.cgColor }
    }

    public static func corner<T: LayerConvertible>(radius: CGFloat) -> Style<T> {
        return .init { $0.caLayer.cornerRadius = radius }
    }
}
