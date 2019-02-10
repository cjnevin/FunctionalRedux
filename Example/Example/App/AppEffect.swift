//
//  AppEffect.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import Core

indirect enum AppEffect {
    case sequence([AppEffect])
    case delay(AppEffect, TimeInterval)
    case action(AppAction)
    case api(ApiEndpoint)
    case log(String)
    case save
    case track(AnalyticsEvent)

    static func async(_ effect: AppEffect) -> AppEffect {
        return .delay(effect, 0)
    }

    static func actions(_ actions: [AppAction]) -> AppEffect {
        return .sequence(actions.map(AppEffect.action))
    }
}

extension AppEffect: Monoid {
    static var identity: AppEffect { return .sequence([]) }
    
    func combine(with other: AppEffect) -> AppEffect {
        switch (self, other) {
        case let (.sequence(a), .sequence(b)): return .sequence(a + b)
        case let (.sequence(a), _): return .sequence(a + [other])
        case let (_, .sequence(b)): return .sequence([self] + b)
        default: return .sequence([self, other])
        }
    }
}
