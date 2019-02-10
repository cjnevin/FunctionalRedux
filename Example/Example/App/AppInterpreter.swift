//
//  Interpreter.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

func appInterpreter(_ deps: Dependencies) -> (@escaping () -> AppState, AppEffect) -> (@escaping (AppAction) -> Void) -> Void {
    return { getState, effect in
        return { callback in
            switch effect {
            case let .sequence(effects):
                effects.forEach { e in
                    appInterpreter(deps)(getState, e)(callback)
                }
            case let .delay(effect, delay):
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    appInterpreter(deps)(getState, effect)(callback)
                }
            case let .action(action):
                callback(action)
            case let .api(endpoint):
                deps.request(endpoint.request).map(endpoint.actions).onResult { (actions) in
                    actions.forEach(callback)
                }
            case let .log(text):
                print("[Logger] \(text)")
            case let .track(event):
                deps.track(event)
            case .save:
                deps.store.set(getState())
            }
        }
    }
}
