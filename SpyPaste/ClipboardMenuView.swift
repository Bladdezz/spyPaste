//
//  ClipboardMenuView.swift
//  SpyPaste
//
//  Created by nathan on 8/20/25.
//


import SwiftUI

struct ClipboardMenuView: View {
    @ObservedObject var monitor: ClipboardMonitor
    @AppStorage("maxClipboardEntries") private var maxClipboardEntries: Int = 10
    @State private var maxEntriesInput: String = "10"

    var body: some View {
        VStack(alignment: .leading) {
            Text("Clipboard History")
                .font(.headline)
                .padding(.bottom, 5)

            Menu("Preferences") {
                Toggle("Enable Clipboard Logging", isOn: $monitor.isLoggingEnabled)
                Toggle("Enable File Monitoring", isOn: $monitor.isFileMonitoringEnabled)
                Divider()
                HStack {
                    Text("Max Clipboard Entries:")
                    TextField(
                        "",
                        text: Binding(
                            get: {
                                maxEntriesInput
                            },
                            set: { newValue in
                                // Allow only numbers and clamp between 1 and 100
                                let filtered = newValue.filter { $0.isNumber }
                                if let intVal = Int(filtered), intVal >= 1, intVal <= 100 {
                                    maxClipboardEntries = intVal
                                    maxEntriesInput = filtered
                                } else if filtered.isEmpty {
                                    maxEntriesInput = ""
                                }
                            }
                        )
                    )
                    .frame(width: 40)
                    .multilineTextAlignment(.trailing)
                    .onAppear {
                        maxEntriesInput = "\(maxClipboardEntries)"
                    }
                }
            }
            .font(.subheadline)
            .padding(.bottom, 5)

            List(monitor.history.prefix(maxClipboardEntries)) { item in
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
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
            .listStyle(PlainListStyle())

            Spacer(minLength: 16) // Add padding at the bottom for Quit button spacing
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}
