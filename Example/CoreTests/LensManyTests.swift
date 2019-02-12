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

private struct A {
    var b: Int
    var c: Int
    var d: Int
}

class LensManyTests: XCTestCase {
    private var sut: A!

    override func setUp() {
        super.setUp()
        sut = A(b: 1, c: 2, d: 3)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    private var bothLens: Lens<A, (Int, Int)> {
        return both(lens(\A.b), lens(\A.c))
    }

    func testBothView() {
        let (b, c) = bothLens.view(sut)
        assert(b).is(equalTo(1))
        assert(c).is(equalTo(2))
    }

    func testBothSet() {
        let _both = bothLens
        sut = _both.set(sut, (3, 4))
        let (b, c) = _both.view(sut)
        assert(b).is(equalTo(3))
        assert(c).is(equalTo(4))
    }

    func testBothMutatingSet() {
        let _both = bothLens
        _both.mutatingSet(&sut, (3, 4))
        let (b, c) = _both.view(sut)
        assert(b).is(equalTo(3))
        assert(c).is(equalTo(4))
    }

    private var manyLens: Lens<A, (Int, Int, Int)> {
        return many(lens(\A.b), lens(\A.c), lens(\A.d))
    }

    func testManyView() {
        let (b, c, d) = manyLens.view(sut)
        assert(b).is(equalTo(1))
        assert(c).is(equalTo(2))
        assert(d).is(equalTo(3))
    }

    func testManySet() {
        let _many = manyLens
        sut = _many.set(sut, (3, 4, 5))
        let (b, c, d) = _many.view(sut)
        assert(b).is(equalTo(3))
        assert(c).is(equalTo(4))
        assert(d).is(equalTo(5))
    }

    func testManyMutatingSet() {
        let _many = manyLens
        _many.mutatingSet(&sut, (3, 4, 5))
        let (b, c, d) = _many.view(sut)
        assert(b).is(equalTo(3))
        assert(c).is(equalTo(4))
        assert(d).is(equalTo(5))
    }

}
