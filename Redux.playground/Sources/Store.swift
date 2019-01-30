import Foundation

public final class Store<S, A, E: Monoid> {
    private let reducer: Reducer<S, A, E>
    private var subscribers: [(S) -> Void] = []
    private var interpreter: (S, E) -> Future<[A]>
    private var currentState: S {
        didSet {
            self.subscribers.forEach { $0(self.currentState) }
        }
    }
    
    public init(reducer: Reducer<S, A, E>, initialState: S, interpreter: @escaping (S, E) -> Future<[A]>) {
        self.reducer = reducer
        self.currentState = initialState
        self.interpreter = interpreter
    }
    
    public func dispatch(_ action: A) {
        let effect = self.reducer.reduce(&self.currentState, action)
        self.interpreter(self.currentState, effect).onResult { [weak self] actions in
            guard let self = self else { return () }
            actions.forEach(self.dispatch)
        }
    }
    
    public func subscriber(_ subscriber: @escaping (S) -> Void) {
        self.subscribers.append(subscriber)
        subscriber(self.currentState)
    }
}
