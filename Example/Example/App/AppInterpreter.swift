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
        case let .sequence(effects):
            return effects.reduce(pure(.identity)) { result, sideEffect in
                zip(result, appInterpreter(deps)(state, sideEffect)).flatMap { a, b in
                    pure(a + b)
                }
            }
        case let .delay(effect, delay):
            return appInterpreter(deps)(state, effect).flatMap { delayed($0, delay: delay) }
        case let .action(action):
            return pure([action])
        case let .api(endpoint):
            return deps.request(endpoint.request).map(endpoint.actions)
        case let .log(text):
            print("[Logger] \(text)")
        case let .track(event):
            deps.track(event)
        case .save:
            deps.store.set(state)
        }
        return pure(.identity)
    }
}
