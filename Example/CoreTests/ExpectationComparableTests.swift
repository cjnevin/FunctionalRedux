//
//  ExpectationComparableTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class ExpectationComparableTests: XCTestCase {
    func testIntGreaterThan() {
        XCTAssertTrue(expect(1) == greaterThan(0))
    }

    func testIntNotGreaterThan() {
        XCTAssertTrue(expect(0) != greaterThan(1))
    }

    func testIntInvertGreaterThan() {
        XCTAssertTrue(expect(0) == !greaterThan(1))
    }

    func testIntLessThan() {
        XCTAssertTrue(expect(0) == lessThan(1))
    }

    func testIntNotLessThan() {
        XCTAssertTrue(expect(1) != lessThan(0))
    }

    func testIntInvertLessThan() {
        XCTAssertTrue(expect(1) == !lessThan(0))
    }
}
