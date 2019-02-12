//
//  Expectation.swift
//  Core
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

public func expect<T>(_ value: T) -> Expectation<T> {
    return .init(value)
}

public func == <T>(lhs: Expectation<T>, rhs: Predicate<T>) -> Bool {
    return lhs.satisfies(rhs)
}

public func != <T>(lhs: Expectation<T>, rhs: Predicate<T>) -> Bool {
    return lhs.satisfies(!rhs)
}

@discardableResult public func equalTo<T: Equatable>(_ value: T) -> Predicate<T> {
    return Predicate<T> { $0 == value }
}

@discardableResult public func greaterThan<T: Comparable>(_ value: T) -> Predicate<T> {
    return Predicate<T> { $0 > value }
}

@discardableResult public func lessThan<T: Comparable>(_ value: T) -> Predicate<T> {
    return Predicate<T> { $0 < value }
}

public struct Expectation<T> {
    public let value: T
    public init(_ value: T) {
        self.value = value
    }
}

extension Expectation {
    public func satisfies(_ predicate: Predicate<T>) -> Bool {
        return predicate.execute(value)
    }
}
