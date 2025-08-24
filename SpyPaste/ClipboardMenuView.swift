//
//  ClipboardMenuView.swift
//  SpyPaste
//
//  Created by nathan on 8/20/25.
//


import SwiftUI

struct ClipboardMenuView: View {
    @ObservedObject var monitor: ClipboardMonitor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Clipboard History")
                .font(.headline)
                .padding(.bottom, 5)

            Toggle("Enable Clipboard Logging", isOn: $monitor.isLoggingEnabled)
                .font(.subheadline)
                .padding(.bottom, 2)

            Toggle("Enable File Monitoring", isOn: $monitor.isFileMonitoringEnabled)
                .font(.subheadline)
                .padding(.bottom, 5)

            List(monitor.history.prefix(10)) { item in
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        switch item.content {
                        case .text(let text):
                            Text(text)
                                .font(.body)
                                .lineLimit(2)
                        case .files(let files):
                            ForEach(files, id: \.self) { file in
                                Text(file.lastPathComponent)
                                    .font(.body)
                                    .lineLimit(1)
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
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}
