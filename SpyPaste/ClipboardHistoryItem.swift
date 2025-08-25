// Define ClipboardHistoryItem if not already defined
struct ClipboardHistoryItem: Hashable {
    var content: Content
    var timestamp: Date
    
    enum Content {
        case text(String)
        case files([URL])
    }
}