//
//  TableViewStyles.swift
//  Render
//
//  Created by Chris Nevin on 13/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import UIKit

extension Styles {
    public enum table: ViewStyles {
        public enum cell: StringStyles, ViewStyles {
            public static func text<T: UITableViewCell>(_ text: String?) -> Style<T> {
                return .init { $0.textLabel?.text = text }
            }

            public static func attributedText<T: UITableViewCell>(_ text: NSAttributedString?) -> Style<T> {
                return .init { $0.textLabel?.attributedText = text }
            }

            public static func detailText<T: UITableViewCell>(_ text: String?) -> Style<T> {
                return .init { $0.detailTextLabel?.text = text }
            }

            public static func detailAttributedText<T: UITableViewCell>(_ text: NSAttributedString?) -> Style<T> {
                return .init { $0.detailTextLabel?.attributedText = text }
            }

            public static func selectionStyle<T: UITableViewCell>(_ text: UITableViewCell.SelectionStyle) -> Style<T> {
                return .init { $0.selectionStyle = text }
            }
        }
    }
}
