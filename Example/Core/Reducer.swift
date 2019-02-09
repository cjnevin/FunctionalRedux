import Foundation

public struct Reducer<S, A, E: Monoid> {
    public let reduce: (inout S, A) -> E
    
    public init(_ reduce: @escaping (inout S, A) -> E) {
        self.reduce = reduce
    }
}

extension Reducer: Monoid {
    public static var identity: Reducer<S, A, E> {
        return Reducer { s, _ in return E.identity }
    }

    public func combine(with other: Reducer<S, A, E>) -> Reducer<S, A, E> {
        return Reducer { s, a in
            return self.reduce(&s, a) <> other.reduce(&s, a)
        }
    }
}

extension Reducer {
    public func lift<T>(state: WritableKeyPath<T, S>) -> Reducer<T, A, E> {
        return Reducer<T, A, E> { t, a in
            self.reduce(&t[keyPath: state], a)
        }
    }
    public func lift<T>(state: Lens<T, S>) -> Reducer<T, A, E> {
        return Reducer<T, A, E> { t, a in
            var s = state.view(t)
            let e = self.reduce(&s, a)
            state.mutatingSet(&t, s)
            return e
        }
    }
}

extension Reducer {
    public func lift<B>(action: Prism<B, A>) -> Reducer<S, B, E> {
        return Reducer<S, B, E> { s, b in
            guard let a = action.preview(b) else { return E.identity }
            return self.reduce(&s, a)
        }
    }
    
    public func lift<B>(effect: Prism<E, B>) -> Reducer<S, A, B> {
        return Reducer<S, A, B> { s, a in
            let e = self.reduce(&s, a)
            return effect.preview(e) ?? B.identity
        }
    }
}

extension Reducer {
    public func lift<T, B>(state: WritableKeyPath<T, S>, action: Prism<B, A>) -> Reducer<T, B, E> {
        return lift(state: state).lift(action: action)
    }
    public func lift<T, B>(state: Lens<T, S>, action: Prism<B, A>) -> Reducer<T, B, E> {
        return lift(state: state).lift(action: action)
    }
}
