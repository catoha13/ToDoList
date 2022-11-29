import Foundation

extension DateFormatter {
    static func convertDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: string) ?? Date()
        formatter.dateFormat = "MMM dd,yyyy"
        return formatter.string(from: newDate)
    }
    
    static func trimDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: string) ?? Date()
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
    
    static func createDueDate(date: Date, time: Date) -> String {
        let dayFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dayFormatter.dateFormat = "YYYY-MM-dd"
        timeFormatter.dateFormat = "hh:mm:ss.ssssss"
        return "\(dayFormatter.string(from: date))T\(timeFormatter.string(from: time))"
    }
    
    static func minutesAndHours(_ strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: strDate) ?? Date()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: newDate)
    }
    
    static func convertCommentDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: string) ?? Date()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: newDate)
    }
    
    static func stringToDate(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        return formatter.date(from: string) ?? Date()
    }
    
    static func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }
}
