//
//  Style.swift
//  Example
//
//  Created by Chris Nevin on 09/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

public typealias Style<A> = Function<A, Void>

extension Function where B == Void {
    public func apply(to candidate: A) {
        execute(candidate)
    }
}

extension Function: Semigroup where B == Void {
    public func combine(with other: Function) -> Function {
        return Function {
            self.execute($0)
            other.execute($0)
        }
    }
}

extension Function: Monoid where B == Void {
    public static var empty: Function {
        return .init { _ in }
    }
}
