//
//  CGSize+Extensions.swift
//  Render
//
//  Created by Chris Nevin on 10/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    public var ceil: CGSize {
        return CGSize(width: Darwin.ceil(width), height: Darwin.ceil(height))
    }
    public var floor: CGSize {
        return CGSize(width: Darwin.floor(width), height: Darwin.floor(height))
    }
    public func multiply(x: CGFloat, y: CGFloat) -> CGSize {
        return CGSize(width: width * x, height: height * y)
    }
    public var half: CGSize {
        return multiply(x: 0.5, y: 0.5)
    }
    public var double: CGSize {
        return multiply(x: 2, y: 2)
    }
}
