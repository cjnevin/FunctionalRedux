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

extension Styles {
    private static let borderStyle = border(width: 0.5) <> border(color: .black)
    private static let cornerStyle = corner(radius: 4)
    private static let borderAndCornerStyle = borderStyle <> cornerStyle

    private static let loginField = capitalization(.none) <> correction(.no)

    public static let emailStyle = placeholder("Enter email")
        <> returnKey(.next)
        <> loginField
        <> keyboard(.emailAddress)
        <> borderAndCornerStyle.promote()

    public static let passwordStyle = placeholder("Enter password")
        <> returnKey(.go)
        <> loginField
        <> secure
        <> borderAndCornerStyle.promote()

    public static let verticalStackStyle = axis(.vertical) <> spacing(20)

    public static let whiteViewStyle = background(.white)

    private static let buttonStyle = titleColor(.black)
        <> titleColor(.gray, for: .disabled)
        <> background(.lightGray).cast()
        <> borderAndCornerStyle.promote()

    public static let submitStyle = buttonStyle <> title("Submit")
}
