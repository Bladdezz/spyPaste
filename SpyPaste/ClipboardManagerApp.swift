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
    @State private var showPreferences = false

    var body: some Scene {
        // Menu bar extra for clipboard history
        MenuBarExtra("📋 ClipLog", systemImage: "doc.on.clipboard") {
            ClipboardMenuView(monitor: monitor)
            Divider()
            Button("Preferences…") {
                showPreferences = true
            }
            .keyboardShortcut(",", modifiers: .command)
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .menuBarExtraStyle(.window)

        // Preferences window
        Window("Preferences", id: "preferences", isPresented: $showPreferences) {
            PreferencesView(monitor: monitor)
        }
        .windowResizability(.contentSize)
    }
}
