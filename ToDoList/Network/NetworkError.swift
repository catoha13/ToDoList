import Foundation

enum NetworkError: Error {
    case nonHTTPResponse
    case requestFailed(Int)
    case serverError(Int)
    case networkError(URLError)
    case decodingError(DecodingError)
    
    var description: String {
        switch self {
        case .nonHTTPResponse:
            return "Non HTTP URL Response Recieved"
        case .requestFailed(let status):
            return "Resieved HTTP status – \(status)"
        case .networkError(let error):
            return "Networking Error – \(error)"
        case .serverError(let error):
            return "Server Error – \(error)"
        case .decodingError(let error):
            return "Decoding Error – \(error)"
        }
    }
}
