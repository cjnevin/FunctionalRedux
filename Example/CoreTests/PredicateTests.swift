//
//  PredicateTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 12/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class PredicateTests: XCTestCase {
    func testFalse() {
        assertFalse(.zero)
    }

    func testTrue() {
        assertTrue(.one)
    }

    func testFalseInvert() {
        assertTrue(!.zero)
    }

    func testTrueInvert() {
        assertFalse(!.one)
    }

    func testFalseMultiplied() {
        assertFalse(.zero * .zero)
    }

    func testFalseAdded() {
        assertFalse(.zero + .zero)
    }

    func testTrueMultiplied() {
        assertTrue(.one * .one)
    }

    func testTrueAdded() {
        assertTrue(.one + .one)
    }

    func testAmpersandFalseAnd() {
        assertFalse(.zero && .zero)
    }

    func testAmpersandFalseOr() {
        assertFalse(.zero || .zero)
    }

    func testAmpersandTrueAnd() {
        assertTrue(.one && .one)
    }

    func testAmpersandTrueOr() {
        assertTrue(.one || .one)
    }
}

private func assertTrue(_ predicate: Predicate<Int>, file: StaticString = #file, line: UInt = #line) {
    assert(0).is(predicate, file: file, line: line)
}

private func assertFalse(_ predicate: Predicate<Int>, file: StaticString = #file, line: UInt = #line) {
    assert(0).isNot(predicate, file: file, line: line)
}
