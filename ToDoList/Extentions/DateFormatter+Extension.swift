import Foundation

extension DateFormatter {
    static func convertDate(_ strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        let newDate = formatter.date(from: strDate) ?? Date()
        formatter.dateFormat = "MMM dd,yyyy"
        return formatter.string(from: newDate)
    }
    
    static func trimDate(_ strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        let newDate = formatter.date(from: strDate) ?? Date()
        formatter.dateFormat = "MMM d/yyyy"
        return formatter.string(from: newDate)
    }
}
