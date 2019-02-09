import Foundation

infix operator <>: AdditionPrecedence

public protocol Semigroup {
    func combine(with other: Self) -> Self
    
    static func <> (lhs: Self, rhs: Self) -> Self
}

extension Semigroup {
    public static func <> (lhs: Self, rhs: Self) -> Self {
        return lhs.combine(with: rhs)
    }
}

extension Numeric where Self: Semigroup {
    public func combine(with other: Self) -> Self {
        return self + other
    }
}

extension Int: Semigroup { }

extension Array: Semigroup {
    public func combine(with other: Array) -> Array {
        return self + other
    }
}

extension String: Semigroup {
    public func combine(with other: String) -> String {
        return self + other
    }
}

extension Bool: Semigroup {
    public func combine(with other: Bool) -> Bool {
        return self && other
    }
}

public func concat<S: Semigroup>(_ xs: [S], initial: S) -> S {
    return xs.reduce(initial, <>)
}
