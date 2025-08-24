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
            if let copiedText = pasteboard.string(forType: .string),
               !copiedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let item = ClipboardItem(content: copiedText, timestamp: Date())
                DispatchQueue.main.async {
                    self.history.insert(item, at: 0)
                }
            }
        }
    }
}
