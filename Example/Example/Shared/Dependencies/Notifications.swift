//
//  Notifications.swift
//  Example
//
//  Created by Chris Nevin on 16/02/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Foundation
import UserNotifications

enum Notification {
    enum Period {
        case time(TimeInterval)
        case date(Date)
    }
    case enable
    case disable
    case send(title: String, body: String, after: Period)
}

protocol NotificationHandler {
    func enable(_ granted: @escaping (Bool) -> Void)
    func disable()
    func send(title: String, body: String, after period: Notification.Period)
}

class NotificationManager: NotificationHandler {
    private let notificationCenter = UNUserNotificationCenter.current()

    func enable(_ granted: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert]) { authorized, _ in
                    granted(authorized)
                }
            case .authorized:
                granted(true)
            default:
                granted(false)
            }
        }
    }

    func disable() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.setNotificationCategories([])
    }

    func send(title: String, body: String, after period: Notification.Period) {
        let trigger = period.trigger
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let request = UNNotificationRequest(identifier: "Period", content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                debugPrint("Error while registering... \(error)")
            }
        }
    }
}

extension Notification.Period {
    var trigger: UNNotificationTrigger {
        switch self {
        case .date(let date):
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: date)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        case .time(let time):
            return UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        }
    }
}
