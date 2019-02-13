//
//  StackViewStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public enum stack: ViewStyles {
        public static func axis(_ value: NSLayoutConstraint.Axis) -> Style<UIStackView> {
            return .init { $0.axis = value }
        }

        public static func spacing(_ value: CGFloat) -> Style<UIStackView> {
            return .init { $0.spacing = value }
        }
    }
}
