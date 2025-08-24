import SwiftUI

struct ClipboardMenuView: View {
    @ObservedObject var monitor: ClipboardMonitor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Clipboard History")
                .font(.headline)
                .padding(.bottom, 5)

            ScrollView {
                ForEach(monitor.history.prefix(10)) { item in
                    VStack(alignment: .leading) {
                        Text(item.content)
                            .font(.body)
                            .lineLimit(2)
                        Text(item.timestamp.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}
