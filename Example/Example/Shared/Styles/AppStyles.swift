//
//  AppStyles.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Render
import UIKit

private enum Colors {
    static let background = UIColor.white
    static let border = UIColor.black

    static let buttonBackground = UIColor.lightGray
    static let buttonText = UIColor.darkGray
    static let buttonDisabledText = UIColor.darkGray

    static let tableBackground = UIColor.groupTableViewBackground
    static let tableCellText = UIColor.black
    static let tableCellDisabledText = UIColor.lightGray

    static let fieldText = UIColor.black
}

private enum Kerning {
    static let none: CGFloat = 0.0
    static let medium: CGFloat = 0.25
    static let high: CGFloat = 0.5
}

private enum Fonts {
    static let `default` = UIFont.systemFont(ofSize: 16)
    static let light = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
    static let bold = UIFont.boldSystemFont(ofSize: 16)
    static let italic = UIFont.italicSystemFont(ofSize: 16)
}

extension LayerStyles {
    private static func _border<T: LayerConvertible>() -> Style<T> {
        return border(width: 0.5) <> border(color: Colors.border)
    }
    private static func _corner<T: LayerConvertible>() -> Style<T> {
        return corner(radius: 4)
    }
    fileprivate static func rounded<T: LayerConvertible>() -> Style<T> {
        return _border() <> _corner()
    }
}

extension Styles.field {
    private static let common = capitalization(.none)
        <> correction(.no)
        <> rounded()
        <> background(Colors.background)

    static let email = common
        <> placeholder("Enter email")
        <> returnKey(.next)
        <> keyboard(.emailAddress)

    static let password = common
        <> placeholder("Enter password")
        <> returnKey(.go)
        <> secure

    private static let _text = font(Fonts.light)
        <> kern(Kerning.medium)
        <> foregroundColor(Colors.fieldText)

    static func text(_ text: String?) -> Style<UITextField> {
        return .init { $0.attributedText = _text.text(text) }
    }

    static func text(_ text: String?) -> Style<TextFieldComponent> {
        return .init { $0.unbox.attributedText = _text.text(text) }
    }
}

extension Styles.stack {
    static let vertical = axis(.vertical) <> spacing(20)
}

extension Styles.table {
    static let view: Style<UITableView> = background(Colors.tableBackground)
}

extension Styles.table.cell {
    static func normal<T: UITableViewCell>(_ text: String?) -> Style<T> {
        let s = font(Fonts.default) <> foregroundColor(Colors.tableCellText)
        return attributedText(s.text(text))
            <> selectionStyle(.default)
            <> background(Colors.background)
    }

    static func disabled<T: UITableViewCell>(_ text: String?) -> Style<T> {
        let s = font(Fonts.italic) <> foregroundColor(Colors.tableCellDisabledText)
        return attributedText(s.text(text))
            <> selectionStyle(.none)
            <> background(Colors.background)
    }

    static func style<T: UITableViewCell>(_ text: String?, isEnabled: Bool) -> Style<T> {
        return isEnabled ? normal(text) : disabled(text)
    }
}

extension Styles.button {
    private static let common = titleColor(Colors.buttonText)
        <> titleColor(Colors.buttonDisabledText, for: .disabled)
        <> background(Colors.buttonBackground)
        <> rounded()

    static let submit = common <> title("Submit")

    static func accessory(_ img: UIImage) -> Style<UIButton> {
        return image(img)
            <> background(Colors.background)
            <> .init {
                $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
                $0.frame = CGRect(origin: .zero, size: img.size.plus(x: 5, y: 0))
            }
    }
}

extension Styles.view {
    static let `default` = background(Colors.background)
}
