# Example

An example that demonstrates how each part of an iOS application may be implemented.

## Core

Redux implementation with type-safety and deferred side-effects with a single point for dependency injection.

### Store

The store holds the latest version of the (S)tate, dispatches (A)ctions to the reducer, notifies subscribers when the (S)tate changes, and calls the interpreter with any (E)ffects that are produced.

### Action

A description of an (A)ction which can be dispatched in the Store to the Reducer to mutate the (S)tate and/or execute (E)ffects.

### Reducer
(inout S, A) -> E

The reducer takes a (S)tate and an (A)ction and returns an updated (S)tate and an (E)ffect.

### Subscriber
(S) -> Void

The subscribers are called whenever the (S)tate is changed.

### Effect

A description of a side effect that describes what task you want to perform. Typical descriptions may include things such as 'save', 'log', 'load url', 'api', 'wait', etc...

### Interpreter
(() -> S, E, (A) -> Void) -> Void

The interpreter takes:
* A function to return the current (S)tate (`() -> S)`)
* An effect to interpret (`E`)
* A closure to dispatch (A)ctions in the store (`(A) -> Void)`)

This is the only place side effects can actually occur, up until this point everything is an 'intent' to do something. This is where you would implement storage, logging, network requests, timers, etc...

#### Dependency Injection

Since the interpreter is the only place we need dependencies it can be created using currying to inject the dependencies on launch.

---

## Render

### Component / WeakComponent

A container for a UI element which allows for wrapping of logic that the element may need.

This allows us to do things like:
* Adding functionality without interfering with existing methods
* Casting
* Composition
* Delegation/callbacks
* Create UI components that we can plug and play

The weak variant (`WeakComponent`) is currently used only by `ViewController`'s as they manage their own lifecycle and will not be deallocated if the component is not set to nil if we were to use a strong variant (`Component`).

If you need to do something complicated in your `UIViewController` you can always subclass (`ViewController`, `TabBarController`, `NavigationController`, `TableViewController`) and pass in your `ViewController` into one of the `xControllerComponent`'s.

### Constraint

A typealias that defines a function which takes the parameters `parent` and `child` and returns an `NSLayoutConstraint`.

An example may be `equalTop(offset: 20)` which means the `child` will sit 20pt below the `topAnchor` of `parent`. Essentially, it's just a cleaned up version of:
`child.topAnchor.constraint(equalTo: parent.topAnchor, constant: offset)`

### Style

Holds a function that applies a style to a particular object when the `apply` method is called. Styles can be composed as they adhere to the `Semigroup` protocol.

`UIView` styles can be applied to `UIViewController`'s views or `UIWindow`'s by calling `promote`.
