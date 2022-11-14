import Foundation

extension Date {
    
    func getCurrentDate() -> Int {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let date = Int(timeInterval)
        return date
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))
        
        let range = calendar.range(of: .day, in: .month,
                                   for: startDate ?? Date())
        
        return range?.compactMap { day -> Date in
            calendar.date(byAdding: .day,
                          value: day - 1,
                          to: startDate ?? Date()) ?? Date()
        } ?? [Date()]
    }
}
