import Foundation

public enum Result<E, A> {
    case success(A)
    case failure(E)

    /// Functor
    public func map<B>(_ f: (A) -> B) -> Result<E, B> {
        switch self {
        case let .success(x): return .success(f(x))
        case let .failure(e): return .failure(e)
        }
    }

    /// Monad
    public func flatMap<B>(_ f: (A) -> Result<E, B>) -> Result<E, B> {
        switch self {
        case let .success(x): return f(x)
        case let .failure(e): return .failure(e)
        }
    }
}

public func pure<E, A>(_ x: A) -> Result<E, A> {
    return .success(x)
}

//Sequential
//public func <*> <E, A, B>(f: Result<E, (A) -> B>, x: Result<E, A>) -> Result<E, B> {
//    return f.flatMap { f in x.map { x in f(x) } }
//}

public func <*> <E: Semigroup, A, B>(f: Result<E, (A) -> B>, x: Result<E, A>) -> Result<E, B> {
    switch (f, x) {
    case let (.success(f), _): return x.map(f)
    case let (.failure(e), .success): return .failure(e)
    case let (.failure(e1), .failure(e2)): return .failure(e1 <> e2)
    }
}

extension Result {
    public enum prism {
        public static var success: Prism<Result<E, A>, A> {
            return Prism<Result<E, A>, A>(
                preview: { if case .success(let a) = $0 { return a } else { return nil } },
                review: { return .success($0) }
            )
        }

        public static var failure: Prism<Result<E, A>, E> {
            return Prism<Result<E, A>, E>(
                preview: { if case .failure(let e) = $0 { return e } else { return nil } },
                review: { return .failure($0) }
            )
        }
    }
}
