//
//  Layer.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public static func border(width: CGFloat) -> Style<CALayer> {
        return .init { $0.borderWidth = width }
    }

    public static func border(color: UIColor) -> Style<CALayer> {
        return .init { $0.borderColor = color.cgColor }
    }

    public static func corner(radius: CGFloat) -> Style<CALayer> {
        return .init { $0.cornerRadius = radius }
    }
}
