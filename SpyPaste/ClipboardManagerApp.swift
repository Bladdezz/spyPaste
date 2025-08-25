//
//  ClipboardManagerApp.swift
//  SpyPaste
//
//  Created by bladdezz on 8/20/25.
//


import SwiftUI
import UserNotifications

@main
struct ClipboardManagerApp: App {
    @StateObject private var monitor = ClipboardMonitor()

    init() {
        // Request notification authorization at app launch
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        MenuBarExtra("📋 ClipLog", systemImage: "doc.on.clipboard") {
            ClipboardMenuView(monitor: monitor)
            Divider()
            Divider()
            HStack {
                Button("Clear History") {
                    monitor.history.removeAll()
                    NSPasteboard.general.clearContents()
                    NotificationHelper.sendNotification(title: "Clipboard History Cleared", body: "Your clipboard history has been erased.")
                }
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            Spacer(minLength: 16)
        }
        .menuBarExtraStyle(.window)
    }
}
