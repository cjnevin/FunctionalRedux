//
//  ButtonStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import UIKit

extension Styles {
    public static let buttonStyle = Style<UIButton> {
        (borderStyle <> cornerStyle).apply(to: $0.layer)
        $0.setTitleColor(.gray, for: .disabled)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor.lightGray
    }

    public static let submitStyle = buttonStyle <> Style<UIButton> {
        $0.setTitle("Submit", for: .normal)
    }
}
