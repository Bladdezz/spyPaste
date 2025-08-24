//
//  ClipboardMonitor.swift
//  SpyPaste
//
//  Created by nathan on 8/20/25.
//


import Foundation
import AppKit
import Combine

class ClipboardMonitor: ObservableObject {
    @Published var history: [ClipboardItem] = []
    @Published var isLoggingEnabled = true
    @Published var isFileMonitoringEnabled = false
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var cancellable: AnyCancellable?

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkClipboard()
            }
    }

    func checkClipboard() {
        guard isLoggingEnabled else { return }
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount

            // Check for text
            if let copiedText = pasteboard.string(forType: .string),
               !copiedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let item = ClipboardItem(content: .text(copiedText), timestamp: Date())
                DispatchQueue.main.async {
                    self.history.insert(item, at: 0)
                }
                return
            }

            // Check for files if enabled
            if isFileMonitoringEnabled,
               let files = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL],
               !files.isEmpty {
                let item = ClipboardItem(content: .files(files), timestamp: Date())
                DispatchQueue.main.async {
                    self.history.insert(item, at: 0)
                }
            }
        }
    }
}
