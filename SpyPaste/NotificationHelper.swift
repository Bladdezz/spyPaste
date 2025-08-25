//
//  NotificationHelper.swift
//  SpyPaste
//
//  Created by bladdezz on 8/25/25.
//

import Foundation
import UserNotifications

struct NotificationHelper {
    static func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
