# FunctionalRedux

Redux implementation with type-safety and deferred side-effects with a single point for dependency injection.

## Store

The store holds the latest version of the (S)tate, dispatches (A)ctions to the reducer, notifies subscribers when the (S)tate changes, and calls the interpreter with any (E)ffects that are produced.

## Action

A description of an (A)ction which can be dispatched in the Store to the Reducer to mutate the (S)tate and/or execute (E)ffects.

## Reducer
(inout S, A) -> E

The reducer takes a (S)tate and an (A)ction and returns an updated (S)tate and an (E)ffect.

## Subscriber
(S) -> Void

The subscribers are called whenever the (S)tate is changed.

## Effect

A description of a side effect that describes what task you want to perform. Typical descriptions may include things such as 'save', 'log', 'load url', 'api', 'wait', etc...

## Interpreter
(S, E) -> Future<[A]>

The interpreter takes the current (S)tate and an (E)ffect and returns an array of (A)ctions.

This is the only place side effects can actually occur, up until this point everything is an 'intent' to do something. This is where you would implement storage, logging, network requests, timers, etc...

### Dependency Injection

Since the interpreter is the only place we need dependencies it can be created using currying to inject the dependencies on launch.
