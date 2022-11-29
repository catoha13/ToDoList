import Foundation

extension Int {
    func trimExpireDate() -> Int {
        var stringDate = String(self)
        stringDate.removeLast(3)
        return Int(stringDate) ?? 0
    }
}
