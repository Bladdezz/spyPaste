import Foundation

// Define ClipboardHistoryItem if not already defined
struct ClipboardHistoryItem: Hashable {
    var content: Content
    var timestamp: Date
    
    enum Content: Hashable {
        case text(String)
        case files([URL])
    }
    
    // Implement the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
        hasher.combine(timestamp)
    }
    
    // Implement the equal operator
    static func == (lhs: ClipboardHistoryItem, rhs: ClipboardHistoryItem) -> Bool {
        return lhs.content == rhs.content && lhs.timestamp == rhs.timestamp
    }
}