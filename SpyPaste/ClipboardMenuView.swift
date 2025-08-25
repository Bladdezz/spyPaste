//
//  ClipboardMenuView.swift
//  SpyPaste
//
//  Created by bladdezz on 8/20/25.
//

import SwiftUI

struct ClipboardMenuView: View {
    @ObservedObject var monitor: ClipboardMonitor
    @AppStorage("maxClipboardEntries") private var maxClipboardEntries: Int = 10
    @State private var preserveFormatting: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView()
            VStack(alignment: .leading) {
                Text("Maximum Clipboard Entries: \(maxClipboardEntries)")
                    .foregroundColor(.gray)
                Slider(value: Binding(
                    get: { Double(maxClipboardEntries) },
                    set: { maxClipboardEntries = Int($0) }
                ), in: 5...50, step: 5)
            }
            preferencesMenu()
            historyListView()
            Spacer(minLength: 16) // Add padding at the bottom for Quit button spacing
        }
        .frame(width: 300, height: 400)
        .padding()
    }
    
    private func headerView() -> some View {
        Text("Clipboard History")
            .font(.headline)
    }
    
    private func preferencesMenu() -> some View {
        Menu("Preferences") {
            Toggle("Enable Clipboard Logging", isOn: $monitor.isLoggingEnabled)
            Toggle("Enable File Monitoring", isOn: $monitor.isFileMonitoringEnabled)
            Toggle("Preserve Formatting", isOn: $preserveFormatting)
        }
        .font(.subheadline)
    }
    
    private func historyListView() -> some View {
        List {
            let reversedHistory = Array(monitor.history.prefix(maxClipboardEntries).reversed())
            ForEach(Array(reversedHistory.enumerated()), id: \.element) { (index, item) in
                historyItemView(item: item, index: index)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func historyItemView(item: ClipboardHistoryItem, index: Int) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                if preserveFormatting {
                    switch item.content {
                    case .text(let text):
                        Text(text)
                            .font(.body)
                            .lineLimit(2)
                    case .files(let files):
                        ForEach(files, id: \.self) { file in
                            HStack {
                                Text(file.lastPathComponent)
                                    .font(.body)
                                    .lineLimit(1)
                                if let size = try? FileManager.default.attributesOfItem(atPath: file.path)[.size] as? NSNumber {
                                    Text("(\(ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: .file)))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                } else {
                    switch item.content {
                    case .text(let text):
                        Text(text)
                            .font(.body)
                            .lineLimit(2)
                            .textContentType(.none) // No content type
                    case .files(let files):
                        ForEach(files, id: \.self) { file in
                            HStack {
                                Text(file.lastPathComponent)
                                    .font(.body)
                                    .lineLimit(1)
                                if let size = try? FileManager.default.attributesOfItem(atPath: file.path)[.size] as? NSNumber {
                                    Text("(\(ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: .file)))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                Text(item.timestamp.formatted(date: .numeric, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            // Show hotkey for the first 5 entries
            if index < 5 {
                Text("⌘\(index + 1)")
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 4)
    }
}
