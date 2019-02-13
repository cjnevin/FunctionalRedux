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
    public enum field: StringStyles, ViewStyles {
        public static func returnKey(_ key: UIReturnKeyType) -> Style<UITextField> {
            return .init { $0.returnKeyType = key }
        }

        public static func keyboard(_ type: UIKeyboardType) -> Style<UITextField> {
            return .init { $0.keyboardType = type }
        }

        public static func capitalization(_ value: UITextAutocapitalizationType) -> Style<UITextField> {
            return .init { $0.autocapitalizationType = value }
        }

        public static func correction(_ value: UITextAutocorrectionType) -> Style<UITextField> {
            return .init { $0.autocorrectionType = value }
        }

        public static func placeholder(_ text: String?) -> Style<UITextField> {
            return .init { $0.placeholder = text }
        }

        public static let secure = isSecure(true)
        public static let unsecure = isSecure(false)

        public static func isSecure(_ secure: Bool) -> Style<UITextField> {
            return .init { $0.isSecureTextEntry = secure }
        }
    }
}
