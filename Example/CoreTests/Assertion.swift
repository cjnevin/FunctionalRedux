//
//  Assertion.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
import Core

struct Assertion<T> {
    let expectation: Expectation<T>
    init(_ value: Expectation<T>) {
        self.expectation = value
    }
}

extension Assertion {
    @discardableResult func `is`(_ predicate: Predicate<T>, file: StaticString = #file, line: UInt = #line) -> Bool {
        let result = expectation == predicate
        XCTAssertTrue(result, file: file, line: line)
        return result
    }
    @discardableResult func isNot(_ predicate: Predicate<T>, file: StaticString = #file, line: UInt = #line) -> Bool {
        return `is`(!predicate)
    }
}

func assert<T>(_ value: T) -> Assertion<T> {
    return Assertion(expect(value))
}
