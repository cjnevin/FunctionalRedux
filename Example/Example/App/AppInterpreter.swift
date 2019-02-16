//
//  Interpreter.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

func appInterpreter(_ deps: Dependencies) -> AppStore.Interpreter {
    return { getState, effect, dispatch in
        switch effect {
        case let .sequence(effects):
            effects.forEach { e in
                appInterpreter(deps)(getState, e, dispatch)
            }
        case let .delay(effect, delay):
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                appInterpreter(deps)(getState, effect, dispatch)
            }
        case let .action(action):
            dispatch(action)
        case let .api(endpoint):
            deps.request(endpoint.request).map(endpoint.actions).onResult { (actions) in
                actions.forEach(dispatch)
            }
        case .notification(.enable):
            deps.notification.enable { authorized in
                DispatchQueue.main.async {
                    dispatch(AppAction.accountAction(.enabledNotifications(authorized)))
                }
            }
        case .notification(.disable):
            deps.notification.disable()
        case let .notification(.send(title, body, period)):
            deps.notification.send(title: title, body: body, after: period)
        case let .log(text):
            deps.log("[Logger] \(text)")
        case let .track(event):
            deps.track(event)
        case .save:
            deps.store.set(getState())
        }
    }
}
