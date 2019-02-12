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
    func testEitherLeftIsFalse() {
        assert(Either<Int, Bool>.prism.right.isCase(.left(0))).is(equalTo(false))
    }

    func testEitherRightIsFalse() {
        assert(Either<Int, Bool>.prism.left.isCase(.right(false))).is(equalTo(false))
    }

    func testEitherPreviewReviewLeft() {
        Either<Int, Bool>.prism.left.assertPreviewReview(.left(1))
    }

    func testEitherPreviewReviewRight() {
        Either<Int, Bool>.prism.right.assertPreviewReview(.right(true))
    }

    func testEitherReviewPreviewLeft() {
        Either<Int, Bool>.prism.left.assertReviewPreview(1)
    }

    func testEitherReviewPreviewRight() {
        Either<Int, Bool>.prism.right.assertReviewPreview(false)
    }

    func testResultSuccessIsFalse() {
        assert(Result<Int, Bool>.prism.success.isCase(.failure(0))).is(equalTo(false))
    }

    func testResultFailureIsFalse() {
        assert(Result<Int, Bool>.prism.failure.isCase(.success(false))).is(equalTo(false))
    }

    func testResultPreviewReviewSuccess() {
        Result<Int, Bool>.prism.success.assertPreviewReview(.success(true))
    }

    func testResultPreviewReviewFailure() {
        Result<Int, Bool>.prism.failure.assertPreviewReview(.failure(0))
    }

    func testResultReviewPreviewSuccess() {
        Result<Int, Bool>.prism.success.assertReviewPreview(false)
    }

    func testResultReviewPreviewFailure() {
        Result<Int, Bool>.prism.failure.assertReviewPreview(1)
    }

    func testOptionalNoneIsFalse() {
        assert(Optional<Int>.prism.isCase(.none)).is(equalTo(false))
    }

    func testOptionalPreviewReviewSome() {
        Optional<Int>.prism.assertPreviewReview(1)
    }

    func testEitherReviewPreviewSome() {
        Optional<Int>.prism.assertReviewPreview(1)
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
