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
    public enum button: StringStyles, ViewStyles {
        public static func title(_ text: String?, for state: UIControl.State = .normal) -> Style<UIButton> {
            return .init { $0.setTitle(text, for: state) }
        }
        
        public static func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Style<UIButton> {
            return .init { $0.setTitleColor(color, for: state) }
        }
        
        public static func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Style<UIButton> {
            return .init { $0.setImage(image, for: state) }
        }
    }
}
