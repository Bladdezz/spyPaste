import Foundation
import AppKit

class ClipboardMonitor: ObservableObject {
    @Published var history: [ClipboardItem] = []
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var timer: Timer?

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    func checkClipboard() {
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
