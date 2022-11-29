import Foundation

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
            return Data(self.utf8).base64EncodedString()
        }

    func convertProgress() -> Double {
        var string = self
        if string.isEmpty {
        } else {
            string.removeLast()
        }
        let number = Double(string)
        return (number ?? 0.4) / 100
    }
}
