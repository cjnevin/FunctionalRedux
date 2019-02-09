import Foundation

public struct Lens<A, B> {
    public let view: (A) -> B
    public let mutatingSet: (inout A, B) -> Void
    
    public init(view: @escaping (A) -> B,
                mutatingSet: @escaping (inout A, B) -> Void) {
        self.view = view
        self.mutatingSet = mutatingSet
    }
    
    public func set(_ whole: A, _ part: B) -> A {
        var result = whole
        self.mutatingSet(&result, part)
        return result
    }
}

public func both<A, B, C>(_ lhs: Lens<A, B>, _ rhs: Lens<A, C>) -> Lens<A, (B, C)> {
    return Lens<A, (B, C)>.init(
        view: { (lhs.view($0), rhs.view($0)) },
        mutatingSet: { whole, parts in
            lhs.mutatingSet(&whole, parts.0)
            rhs.mutatingSet(&whole, parts.1)
    })
}

public func lens<A, B>(_ keyPath: WritableKeyPath<A, B>) -> Lens<A, B> {
    return Lens<A, B>(
        view: { $0[keyPath: keyPath] },
        mutatingSet: { whole, part in whole[keyPath: keyPath] = part }
    )
}
