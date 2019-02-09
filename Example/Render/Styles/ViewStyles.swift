//
//  ViewStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public static func background(_ color: UIColor) -> Style<UIView> {
        return .init { $0.backgroundColor = color }
    }
}
