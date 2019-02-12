//
//  MonoidTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class MonoidLawTests: XCTestCase {
    func testArrayEmpty() {
        assert([Int].empty).is(equalTo([]))
    }

    func testBoolEmpty() {
        assert(Bool.empty).is(equalTo(true))
    }

    func testIntEmpty() {
        assert(Int.empty).is(equalTo(0))
    }

    func testStringEmpty() {
        assert(String.empty).is(equalTo(""))
    }

    func testArrayEmptyJoinedIsEmpty() {
        assert([[Int].empty, [Int].empty].joined()).is(equalTo([]))
    }

    func testBoolEmptyJoinedIsEmpty() {
        assert([Bool.empty, Bool.empty].joined()).is(equalTo(true))
    }

    func testIntEmptyJoinedIsEmpty() {
        assert([Int.empty, Int.empty].joined()).is(equalTo(0))
    }

    func testStringEmptyJoinedIsEmpty() {
        assert([String.empty, String.empty].joined()).is(equalTo(""))
    }
}
