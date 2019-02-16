//
//  Dependencies.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation

struct Dependencies {
    let request = createApi(with: ApiConfiguration(basePath: "http://test.com"))
    let track = createAnalytics(with: FakeTracker())
    let store = getStorage()
    let log: (Any) -> Void = { value in print(value) }
    let notification: NotificationHandler = NotificationManager()
}
