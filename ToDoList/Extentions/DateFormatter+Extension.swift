import Foundation

extension DateFormatter {
    static func dueDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: string) ?? Date()
        formatter.dateFormat = "MMM dd,yyyy"
        return formatter.string(from: newDate)
    }
    
    static func headerDate(_ string: String) -> String {
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
    
    static func minutesAndHours(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        let date = formatter.date(from: string)
        formatter.dateFormat = "hh:mm a"
        let stringDate = formatter.string(from: date ?? Date())
        let newDate = formatter.date(from: stringDate) ?? Date()
        
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
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: string) ?? Date()
    }
    
    static func checkTaskDueDate(from stringDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: stringDate)
        let diffComponents = Calendar.current.dateComponents([.hour], from: Date(), to: date ?? Date())
        let hours = diffComponents.hour ?? 0
        if hours <= 2 {
            return true
        } else {
            return false
        }
    }
    
    static func checkTaskComplitionDate(from stringDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: stringDate)
        let diffComponents = Calendar.current.dateComponents([.hour], from: Date(), to: date ?? Date())
        let hours = diffComponents.hour ?? 0
        if hours <= 0 {
            return true
        } else {
            return false
            
        }
    }
}
