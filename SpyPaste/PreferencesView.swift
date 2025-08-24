import SwiftUI

struct PreferencesView: View {
    @ObservedObject var monitor: ClipboardMonitor

    var body: some View {
        Form {
            Toggle("Enable Clipboard Logging", isOn: $monitor.isLoggingEnabled)
            Toggle("Enable File Monitoring", isOn: $monitor.isFileMonitoringEnabled)
        }
        .padding()
        .frame(width: 350)
    }
}