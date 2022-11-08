import Foundation

extension DateFormatter {
    static var pickDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
}


//static var month: DateFormatter {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM"
//    return formatter
//}

