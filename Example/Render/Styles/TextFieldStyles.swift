//
//  TextField.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import UIKit

extension Styles {
    public static let textStyle = Style<UITextField> {
        (borderStyle <> cornerStyle).apply(to: $0.layer)
    }

    public static let emailStyle = textStyle <> Style<UITextField> {
        $0.placeholder = "Enter email"
        $0.returnKeyType = .next
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .emailAddress
    }

    public static let passwordStyle = textStyle <> Style<UITextField> {
        $0.placeholder = "Enter password"
        $0.returnKeyType = .go
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.isSecureTextEntry = true
    }
}
