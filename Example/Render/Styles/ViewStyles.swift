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

public protocol ViewStyles: LayerStyles { }

extension ViewStyles {
    public static func background<T: UIView>(_ color: UIColor) -> Style<T> {
        return .init { $0.backgroundColor = color }
    }
}
