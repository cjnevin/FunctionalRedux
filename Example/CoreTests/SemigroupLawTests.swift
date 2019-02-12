//
//  SemigroupTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

final class SemigroupLawTests: XCTestCase {
    func testBoolAssociativity() {
        assertSemigroupLaw(x: true, y: false, z: true)
    }

    func testIntAssociativity() {
        assertSemigroupLaw(x: 1, y: 2, z: 3)
    }

    func testStringAssociativity() {
        assertSemigroupLaw(x: "x", y: "y", z: "z")
    }

    func testArrayAssociativity() {
        assertSemigroupLaw(x: [1], y: [2], z: [3])
    }

    func testConcat() {
        assert(concat([1, 2, 3], initial: 0)).is(equalTo(6))
    }
}

/// Instances should satisfy the associativity law:
/// x <> (y <> z) = (x <> y) <> z
private func assertSemigroupLaw<T: Equatable & Semigroup>(x: T, y: T, z: T, file: StaticString = #file, line: UInt = #line) {
    assert(x <> (y <> z)).is(equalTo((x <> y) <> z), file: file, line: line)
}
