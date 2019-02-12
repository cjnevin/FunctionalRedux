//
//  ExpectationTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class ExpectationEqualTests: XCTestCase {
    func testIntEqual() {
        XCTAssertTrue(expect(1) == equalTo(1))
    }

    func testIntNotEqual() {
        XCTAssertTrue(expect(1) != equalTo(2))
    }

    func testIntInvertEqual() {
        XCTAssertTrue(expect(1) == !equalTo(2))
    }

    func testBoolEqual() {
        XCTAssertTrue(expect(true) == equalTo(true))
    }

    func testBoolNotEqual() {
        XCTAssertTrue(expect(true) != equalTo(false))
    }

    func testBoolInvertEqual() {
        XCTAssertTrue(expect(true) == !equalTo(false))
    }

    func testStringEqual() {
        XCTAssertTrue(expect("a") == equalTo("a"))
    }

    func testStringNotEqual() {
        XCTAssertTrue(expect("a") != equalTo("b"))
    }

    func testStringInvertEqual() {
        XCTAssertTrue(expect("a") == !equalTo("b"))
    }

    func testArrayEqual() {
        XCTAssertTrue(expect([1]) == equalTo([1]))
    }

    func testArrayNotEqual() {
        XCTAssertTrue(expect([1]) != equalTo([2]))
    }

    func testArrayInvertEqual() {
        XCTAssertTrue(expect([1]) == !equalTo([2]))
    }
}
