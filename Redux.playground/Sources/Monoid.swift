import Foundation

public protocol Monoid: Semigroup {
    static var identity: Self { get }
}

extension Numeric where Self: Monoid {
    public static var identity: Self { return 0 }
}

extension Int: Monoid { }

extension Bool: Monoid {
    public static let identity = true
}

extension String: Monoid {
    public static let identity = ""
}

extension Array: Monoid {
    public static var identity: Array {
        return []
    }
}

public func concat<M: Monoid>(_ xs: [M]) -> M {
    return xs.reduce(M.identity, <>)
}
