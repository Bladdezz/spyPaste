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
            Text("Clipboard History")
                .font(.headline)
            
            Menu("Preferences") {
                Toggle("Enable Clipboard Logging", isOn: $monitor.isLoggingEnabled)
                Toggle("Enable File Monitoring", isOn: $monitor.isFileMonitoringEnabled)
                Divider()
                HStack(spacing: 10) {
                    Text("Max Clipboard Entries:")
                    Text("\(maxClipboardEntries)")
                        .foregroundColor(.gray)
                        .padding(.leading, 5) // Add some padding next to the text
                    
                    Toggle("Preserve Formatting", isOn: $preserveFormatting)
                }
            }
            .font(.subheadline)
            
            List {
                ForEach(monitor.history.prefix(maxClipboardEntries), id: \.self) { item in
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
                                        .textContentType(.plainText) // Convert to plain text
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
                        Button(action: {
                            monitor.setClipboard(to: item)
                        }) {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .imageScale(.large)
                                .help("Copy to Clipboard")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(PlainListStyle())
            
            Spacer(minLength: 16) // Add padding at the bottom for Quit button spacing
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}
