//
//  Function.swift
//  Core
//
//  Created by Chris Nevin on 24/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public struct Function<A, B> {
    public let execute: (A) -> B

    public init(_ f: @escaping (A) -> B) {
        self.execute = f
    }
}
