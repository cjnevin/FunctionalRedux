import Foundation
import Dispatch

public class Future<A> {
    public let f: (@escaping (A) -> ()) -> Void
    private(set) public var result: A?
    
    public init(_ f: @escaping (@escaping (A) -> ()) -> Void) {
        self.f = f
    }
    
    public func onResult(_ callback: @escaping (A) -> ()) {
        self.f { a in
            self.result = a
            callback(a)
        }
    }
    
    public func map<B>(_ g: @escaping (A) -> B) -> Future<B> {
        return Future<B> { f in
            self.onResult { x in f(g(x)) }
        }
    }
    
    public func flatMap<B>(_ g: @escaping (A) -> Future<B>) -> Future<B> {
        return Future<B> { f in
            self.onResult { x in g(x).onResult(f) }
        }
    }
    
    public init(pure value: A) {
        self.f = { f in f(value) }
    }
}

public func zip<A, B>(_ x: Future<A>, _ y: Future<B>) -> Future<(A, B)> {
    return Future<(A, B)> { f in
        x.onResult { x in if let y = y.result { f((x, y)) } }
        y.onResult { y in if let x = x.result { f((x, y)) } }
    }
}

public func <*> <A, B>(f: Future<(A) -> B>, x: Future<A>) -> Future<B> {
    // Concurrent
    return zip(f, x).map { f, x in f(x) }
    // Sequential    return f.flatMap { f in x.map { x in f(x) } }
}

public func pure<A>(_ x: A) -> Future<A> {
    return Future<A> { f in f(x) }
}

public func delayed<A>(_ x: A, delay: TimeInterval = 1) -> Future<A> {
    return Future<A> { f in
        debugPrint("delaying...")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            debugPrint("done!")
            f(x)
        }
    }
}
