//
//  LensLawTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

// getSet: if I get a B from a data structure A, and then I set it back, A is not going to change;
// setGet: if I set a B into a data structure A and then I get it back, the retrieved B must be equal to the initial one;
// setSet: set is idempotent, meaning that if I set a B into an A multiple times, it’s going to be exactly as if I set it just once.

private struct A {
    var b: Int
}

class LensLawTests: XCTestCase {
    private var sut: A!
    private var lens: Lens<A, Int>!

    override func setUp() {
        super.setUp()
        sut = A(b: 1)
        lens = Core.lens(\A.b)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        lens = nil
    }

    func testGetSet() {
        sut = lens.set(sut, lens.view(sut))
        assert(sut.b).is(equalTo(1))
    }

    func testSetGet() {
        sut = lens.set(sut, 2)
        assert(lens.view(sut)).is(equalTo(2))
    }

    func testSetSet() {
        for x in 0..<100 {
            sut = lens.set(sut, x)
            assert(lens.view(sut)).is(equalTo(x))
        }
    }

    func testGetMutatingSet() {
        lens.mutatingSet(&sut, lens.view(sut))
        assert(sut.b).is(equalTo(1))
    }

    func testMutatingSetGet() {
        lens.mutatingSet(&sut, 2)
        assert(lens.view(sut)).is(equalTo(2))
    }

    func testMutatingSetSet() {
        for x in 0..<100 {
            lens.mutatingSet(&sut, x)
            assert(lens.view(sut)).is(equalTo(x))
        }
    }
}
