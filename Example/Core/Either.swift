import Foundation

public enum Either<A, B> {
    case left(A)
    case right(B)
}

extension Either {
    public enum prism {
        public static var left: Prism<Either<A, B>, A> {
            return Prism<Either<A, B>, A>(
                preview: { if case .left(let a) = $0 { return a } else { return nil } },
                review: { return .left($0) }
            )
        }
        public static var right: Prism<Either<A, B>, B> {
            return Prism<Either<A, B>, B>(
                preview: { if case .right(let b) = $0 { return b } else { return nil } },
                review: { return .right($0) }
            )
        }
    }
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
