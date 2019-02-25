//
//  StringStyles.swift
//  Render
//
//  Created by Chris Nevin on 13/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import UIKit

public protocol StringStyles { }

public typealias StringAttributes = DictionaryHolder<NSAttributedString.Key, Any>

public extension StringStyles {
    public static func attributed(_ attributes: StringAttributes) -> Style<NSMutableAttributedString> {
        return .init { $0.addAttributes(attributes.value, range: NSRange($0.string.startIndex..<$0.string.endIndex, in: $0.string)) }
    }

    public static func attributed(_ attributes: StringAttributes, range: Range<String.Index>) -> Style<NSMutableAttributedString> {
        return .init { $0.addAttributes(attributes.value, range: NSRange(range, in: $0.string)) }
    }

    public static func font(_ value: UIFont) -> Style<StringAttributes> {
        return .init { $0.add(key: .font, value: value) }
    }

    public static func foregroundColor(_ value: UIColor) -> Style<StringAttributes> {
        return .init { $0.add(key: .foregroundColor, value: value) }
    }

    public static func kern(_ value: CGFloat) -> Style<StringAttributes> {
        return .init { $0.add(key: .kern, value: value) }
    }

    public static func baselineOffset(_ value: CGFloat) -> Style<StringAttributes> {
        return .init { $0.add(key: .baselineOffset, value: value) }
    }

    public static func paragraphStyle(_ value: NSMutableParagraphStyle) -> Style<StringAttributes> {
        return .init { $0.add(key: .paragraphStyle, value: value) }
    }
}

extension Styles {
    public enum paragraph {
        public static func alignment(_ value: NSTextAlignment) -> Style<NSMutableParagraphStyle> {
            return .init { $0.alignment = value }
        }

        public static func lineBreakMode(_ value: NSLineBreakMode) -> Style<NSMutableParagraphStyle> {
            return .init { $0.lineBreakMode = value }
        }

        public static func minimumLineHeight(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.minimumLineHeight = value }
        }

        public static func maximumLineHeight(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.maximumLineHeight = value }
        }

        public static func lineHeightMultiple(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.lineHeightMultiple = value }
        }

        public static func lineSpacing(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.lineSpacing = value }
        }

        public static func paragraphSpacing(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.paragraphSpacing = value }
        }

        public static func firstLineHeadIndent(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.firstLineHeadIndent = value }
        }

        public static func headIndent(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.headIndent = value }
        }

        public static func tailIndent(_ value: CGFloat) -> Style<NSMutableParagraphStyle> {
            return .init { $0.tailIndent = value }
        }
    }
}

extension Dictionary {
    mutating func add(key: Key, value: Value) {
        merge([key: value], uniquingKeysWith: { (key, _ ) in key })
    }
}

public final class DictionaryHolder<Key: Hashable, Value> {
    private(set) var value: [Key: Value] = [:]

    func add(key: Key, value v: Value) {
        value.add(key: key, value: v)
    }
}

extension Style where A == StringAttributes, B == Void {
    public func text(_ text: String?) -> NSAttributedString {
        guard let text = text else { return .init() }
        let attr = StringAttributes()
        apply(to: attr)
        return NSAttributedString(string: text, attributes: attr.value)
    }
}
