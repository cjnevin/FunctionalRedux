import Foundation

public enum Either<A, B> {
    case left(A)
    case right(B)
}

public func either<A, B, C>(_ lhs: Prism<A, B>, _ rhs: Prism<A, C>) -> Prism<A, Either<B, C>> {
    return Prism<A, Either<B, C>>.init(
        preview: {
            lhs.preview($0).map(Either.left) ?? rhs.preview($0).map(Either.right)
    },
        review: {
            switch $0 {
            case let .left(b): return lhs.review(b)
            case let .right(c): return rhs.review(c)
            }
    })
}
