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
    private let urlHandler = URLHandler()
    @State private var showPreferences = false

    init() {
        urlHandler.openPreferences = {
            DispatchQueue.main.async {
                self.showPreferences = true
            }
        }
    }

    var body: some Scene {
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

        Window("Preferences", id: "preferences", isPresented: $showPreferences) {
            PreferencesView(monitor: monitor)
        }
    }
}
