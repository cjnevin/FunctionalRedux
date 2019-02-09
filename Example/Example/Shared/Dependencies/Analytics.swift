//
//  Analytics.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

enum AnalyticsEvent {
    enum AccountEvent {
        case logInPressed
    }
    case accountEvent(AccountEvent)
}

protocol Tracker {
    func track(_ event: AnalyticsEvent)
}

func createAnalytics(with trackers: Tracker...) -> (AnalyticsEvent) -> Void {
    return { event in
        trackers.forEach { $0.track(event) }
    }
}

struct FakeTracker: Tracker {
    func track(_ event: AnalyticsEvent) {
        print("Track: \(event)")
    }
}
