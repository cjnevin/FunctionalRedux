import Foundation

public final class Store<S, A, E: Monoid> {
    public typealias Interpreter = (@escaping () -> S, E, @escaping (A) -> Void) -> Void
    public typealias Token = Int

    private let reducer: Reducer<S, A, E>
    private var subscribers: [Token: (S) -> Void] = [:]
    private var interpreter: Interpreter
    private var token = (0...).makeIterator()

    private var currentState: S {
        didSet { self.subscribers.values.forEach { $0(self.currentState) } }
    }
    
    public init(reducer: Reducer<S, A, E>, initialState: S, interpreter: @escaping Interpreter) {
        self.reducer = reducer
        self.currentState = initialState
        self.interpreter = interpreter
    }
    
    public func dispatch(_ action: A) {
        assert(Thread.isMainThread)
        let effect = self.reducer.reduce(&self.currentState, action)
        self.interpreter({ self.currentState }, effect, self.dispatch)
    }
    
    public func subscribe(_ subscriber: @escaping (S) -> Void) -> Token {
        let tkn = self.token.next()!
        self.subscribers[tkn] = subscriber
        subscriber(self.currentState)
        return tkn
    }

    public func unsubscribe(_ token: Token) {
        self.subscribers.removeValue(forKey: token)
    }
}
