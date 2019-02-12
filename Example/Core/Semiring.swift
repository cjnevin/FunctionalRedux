//
//  Semiring.swift
//  Core
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//
//  Credit: https://www.fewbutripe.com/swift/math/algebra/semiring/2017/08/01/semirings-and-predicates.html

import Foundation

public protocol Semiring {
    static func + (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static var zero: Self { get }
    static var one: Self { get }
}

extension Bool: Semiring {
    public static func + (lhs: Bool, rhs: Bool) -> Bool {
        return lhs || rhs
    }

    public static func * (lhs: Bool, rhs: Bool) -> Bool {
        return lhs && rhs
    }

    public static let zero = false
    public static let one = true
}

extension Int: Semiring {
    public static let zero = 0
    public static let one = 1
}

public struct FunctionS<A, S: Semiring> {
    public let execute: (A) -> S

    public init(_ execute: @escaping (A) -> S) {
        self.execute = execute
    }
}

extension FunctionS: Semiring {
    public static func + (lhs: FunctionS, rhs: FunctionS) -> FunctionS {
        return FunctionS { lhs.execute($0) + rhs.execute($0) }
    }

    public static func * (lhs: FunctionS, rhs: FunctionS) -> FunctionS {
        return FunctionS { lhs.execute($0) * rhs.execute($0) }
    }

    public static var zero: FunctionS {
        return FunctionS { _ in S.zero }
    }

    public static var one: FunctionS {
        return FunctionS { _ in S.one }
    }
}
