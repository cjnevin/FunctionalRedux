//
//  Layer.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import UIKit

extension Styles {
    public static let borderStyle = Style<CALayer> {
        $0.borderColor = UIColor.black.cgColor
        $0.borderWidth = 0.5
    }

    public static let cornerStyle = Style<CALayer> {
        $0.cornerRadius = 4
    }
}
