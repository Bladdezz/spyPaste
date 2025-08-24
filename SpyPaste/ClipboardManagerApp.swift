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
        // Menu bar extra for clipboard history
        MenuBarExtra("📋 ClipLog", systemImage: "doc.on.clipboard") {
            ClipboardMenuView(monitor: monitor)
        }
        .menuBarExtraStyle(.window)
    }
}
