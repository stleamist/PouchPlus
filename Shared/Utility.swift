import Foundation

enum Utility {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func dateString(from date: Date?) -> String {
        guard let date = date else {
            return "Unknown"
        }
        return dateFormatter.string(from: date)
    }
}
