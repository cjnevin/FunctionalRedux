import Foundation

public protocol Monoid: Semigroup {
    static var empty: Self { get }
}

extension Numeric where Self: Monoid {
    public static var empty: Self { return 0 }
}

extension Int: Monoid { }

extension Bool: Monoid {
    public static let empty = true
}

extension String: Monoid {
    public static let empty = ""
}

extension Array: Monoid {
    public static var empty: Array {
        return []
    }
}

public func concat<M: Monoid>(_ values: [M]) -> M {
    return values.reduce(M.empty, <>)
}

extension Sequence where Element: Monoid {
    public func joined() -> Element {
        return concat(Array(self))
    }
}
