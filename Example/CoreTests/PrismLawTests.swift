//
//  PrismLawTests.swift
//  CoreTests
//
//  Created by Chris Nevin on 12/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import XCTest
@testable import Core

class PrismLawTests: XCTestCase {
    typealias sut = Either<Int, Bool>

    func testPreviewReviewLeft() {
        sut.prism.left.assertPreviewReview(.left(1))
    }

    func testPreviewReviewRight() {
        sut.prism.right.assertPreviewReview(.right(true))
    }

    func testReviewPreviewLeft() {
        sut.prism.left.assertReviewPreview(1)
    }

    func testReviewPreviewRight() {
        sut.prism.right.assertReviewPreview(false)
    }
}

private extension Prism {
    /// previewReview: if I’m able to preview a B from an A, reviewing it yields exactly the same A.
    func assertPreviewReview(_ value: A, file: StaticString = #file, line: UInt = #line) {
        let result = preview(value).map(review).map(isCase) ?? false
        assert(result).is(equalTo(true), file: file, line: line)
    }
}

private extension Prism where B: Equatable {
    /// reviewPreview: if I construct an A by reviewing a B, I must be able to preview exactly the same B.
    func assertReviewPreview(_ value: B, file: StaticString = #file, line: UInt = #line) {
        assert(preview(review(value))).is(equalTo(value))
    }
}
