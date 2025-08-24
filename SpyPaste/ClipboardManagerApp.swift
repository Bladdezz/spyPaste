//
//  ClipboardManagerApp.swift
//  SpyPaste
//
//  Created by nathan on 8/20/25.
//


import SwiftUI

@main
struct ClipboardManagerApp: App {
    @StateObject private var monitor = ClipboardMonitor()

    var body: some Scene {
        MenuBarExtra("📋 ClipLog", systemImage: "doc.on.clipboard") {
            ClipboardMenuView(monitor: monitor)
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            
            Spacer(minLength: 16)
        }
        .menuBarExtraStyle(.window)
    }
}
