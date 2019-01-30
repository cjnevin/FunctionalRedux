import Foundation

infix operator <>: AdditionPrecedence

public protocol Semigroup {
    static func <> (lhs: Self, rhs: Self) -> Self
}

extension Numeric where Self: Semigroup {
    public static func <> (lhs: Self, rhs: Self) -> Self {
        return lhs + rhs
    }
}

extension Int: Semigroup { }

extension Array: Semigroup {
    public static func <> (lhs: Array, rhs: Array) -> Array {
        return lhs + rhs
    }
}

extension String: Semigroup {
    public static func <> (lhs: String, rhs: String) -> String {
        return lhs + rhs
    }
}

extension Bool: Semigroup {
    public static func <> (lhs: Bool, rhs: Bool) -> Bool {
        return lhs && rhs
    }
}

public func concat<S: Semigroup>(_ xs: [S], initial: S) -> S {
    return xs.reduce(initial, <>)
}
