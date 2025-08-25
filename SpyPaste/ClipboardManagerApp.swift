//
//  ClipboardManagerApp.swift
//  SpyPaste
//
//  Created by bladdezz on 8/20/25.
//


import SwiftUI

@main
struct ClipboardManagerApp: App {
    @StateObject private var monitor = ClipboardMonitor()

    var body: some Scene {
        MenuBarExtra("📋 ClipLog", systemImage: "doc.on.clipboard") {
            ClipboardMenuView(monitor: monitor)
            Divider()
            HStack {
                Button("Clear History") {
                    monitor.history.removeAll()
                    NSPasteboard.general.clearContents()
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
