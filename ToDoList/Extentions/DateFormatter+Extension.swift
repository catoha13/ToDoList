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
    
    static func formatCalendarDayDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    static func formatDateDayMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    static func formatDueDate(date: Date, time: Date) -> String {
        let dayFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dayFormatter.dateFormat = "YYYY-MM-dd"
        timeFormatter.dateFormat = "hh:mm:ss.ssssss"
        return "\(dayFormatter.string(from: date))T\(timeFormatter.string(from: time))"
    }
    
    static func convertCommentDate(_ strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        let newDate = formatter.date(from: strDate) ?? Date()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: newDate)
    }
}
