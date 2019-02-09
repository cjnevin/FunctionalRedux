//
//  StackViewStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public static let verticalStackStyle = Style<UIStackView> {
        $0.axis = .vertical
        $0.spacing = 20
    }
}
