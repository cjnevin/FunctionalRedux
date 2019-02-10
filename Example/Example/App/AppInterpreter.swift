//
//  Interpreter.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

func appInterpreter(_ deps: Dependencies) -> (AppState, AppEffect) -> Future<[AppAction]> {
    return { state, effect in
        switch effect {
        case .sequence(let effects):
            return effects.reduce(pure(.identity)) { result, sideEffect in
                zip(result, appInterpreter(deps)(state, sideEffect)).flatMap { a, b in
                    pure(a + b)
                }
            }
        case .api(let endpoint):
            return deps.request(endpoint.request).map(endpoint.actions)
        case .save:
            deps.store.set(state)
        case .log(let text):
            print("[Logger] \(text)")
        case .track(let event):
            deps.track(event)
        }
        return pure(.identity)
    }
}
