import Foundation

precedencegroup Applicative {
    associativity: left
}

infix operator <*>: Applicative

public func <*> <A, B>(f: ((A) -> B)?, x: A?) -> B? {
    return apply(f, to: x)
}

public func apply<A, B>(_ f: ((A) -> B)?, to x: A?) -> B? {
    return f.flatMap { f in x.map { x in f(x) } }
}

public func pure<A>(_ x: A) -> A? {
    return .some(x)
}

// map:     ((A -> B),  A?) -> B?
// <*>:     ((A -> B)?, A?) -> B?
// flatMap: ((A -> B?), A?) -> B?
