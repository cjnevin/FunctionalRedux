import Foundation

public final class Store<S, A, E: Monoid> {
    private let reducer: Reducer<S, A, E>
    private var subscribers: [String: (S) -> Void] = [:]
    private var interpreter: (S, E) -> Future<[A]>
    private var currentState: S {
        didSet {
            self.subscribers.values.forEach { $0(self.currentState) }
        }
    }
    
    public init(reducer: Reducer<S, A, E>, initialState: S, interpreter: @escaping (S, E) -> Future<[A]>) {
        self.reducer = reducer
        self.currentState = initialState
        self.interpreter = interpreter
    }
    
    public func dispatch(_ action: A) {
        assert(Thread.isMainThread)
        let effect = self.reducer.reduce(&self.currentState, action)
        self.interpreter(self.currentState, effect).onResult { [weak self] actions in
            guard let self = self else { return () }
            actions.forEach(self.dispatch)
        }
    }
    
    public func subscribe(_ subscriber: @escaping (S) -> Void) -> String {
        let token = UUID().uuidString
        subscribers[token] = subscriber
        subscriber(self.currentState)
        return token
    }

    public func unsubscribe(_ token: String) {
        subscribers.removeValue(forKey: token)
    }
}