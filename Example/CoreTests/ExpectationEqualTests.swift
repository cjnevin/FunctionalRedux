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
        XCTAssertTrue(expect(1).satisfies(equalTo(1)))
    }

    func testIntNotEqual() {
        XCTAssertFalse(expect(1).satisfies(equalTo(2)))
    }

    func testIntInvertEqual() {
        XCTAssertTrue(expect(1).satisfies(!equalTo(2)))
    }

    func testBoolEqual() {
        XCTAssertTrue(expect(true).satisfies(equalTo(true)))
    }

    func testBoolNotEqual() {
        XCTAssertFalse(expect(true).satisfies(equalTo(false)))
    }

    func testBoolInvertEqual() {
        XCTAssertTrue(expect(true).satisfies(!equalTo(false)))
    }

    func testStringEqual() {
        XCTAssertTrue(expect("a").satisfies(equalTo("a")))
    }

    func testStringNotEqual() {
        XCTAssertFalse(expect("a").satisfies(equalTo("b")))
    }

    func testStringInvertEqual() {
        XCTAssertTrue(expect("a").satisfies(!equalTo("b")))
    }

    func testArrayEqual() {
        XCTAssertTrue(expect([1]).satisfies(equalTo([1])))
    }

    func testArrayNotEqual() {
        XCTAssertFalse(expect([1]).satisfies(equalTo([2])))
    }

    func testArrayInvertEqual() {
        XCTAssertTrue(expect([1]).satisfies(!equalTo([2])))
    }
}
