//
//  StorageTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 11/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

final class StorageTests: XCTestCase {
    private var a: Memory<Int>!
    private var b: Memory<Int>!
    private var c: Memory<Int>!

    var sut: Storage<Int> {
        return [a, b, c].combined()
    }

    override func setUp() {
        super.setUp()
        a = Memory<Int>()
        b = Memory<Int>()
        c = Memory<Int>()
    }

    override func tearDown() {
        super.tearDown()
        a = nil
        b = nil
        c = nil
    }

    func testSetNone_thenGetSut_isNull() {
        XCTAssertNil(sut.get())
    }

    func testSetA_thenGetSut_setsBAndC() {
        a.storage.set(1)
        XCTAssertEqual(sut.get(), 1)
        XCTAssertEqual(b.storage.get(), 1)
        XCTAssertEqual(c.storage.get(), 1)
    }

    func testSetB_thenGetSut_setsAAndC() {
        b.storage.set(1)
        XCTAssertEqual(sut.get(), 1)
        XCTAssertEqual(a.storage.get(), 1)
        XCTAssertEqual(c.storage.get(), 1)
    }

    func testSetC_thenGetSut_setsAAndB() {
        c.storage.set(1)
        XCTAssertEqual(sut.get(), 1)
        XCTAssertEqual(a.storage.get(), 1)
        XCTAssertEqual(b.storage.get(), 1)
    }

    func testSetSut_setsAll() {
        sut.set(1)
        XCTAssertEqual(a.storage.get(), 1)
        XCTAssertEqual(b.storage.get(), 1)
        XCTAssertEqual(c.storage.get(), 1)
    }
}

private extension Sequence {
    func combined<T>() -> Storage<T> where Element == Memory<T> {
        var all = compactMap { $0.storage }
        assert(all.count > 0)
        if all.count == 1 { return all[0] }
        let first = all.removeFirst()
        return all.reduce(first, <>)
    }
}

private final class Memory<T> {
    private var value: T?
    private(set) var storage: Storage<T>!

    init() {
        storage = Storage<T>(get: { [weak self] in
            return self?.value
            }, set: { [weak self] newValue in
                self?.value = newValue
        })
    }
}
