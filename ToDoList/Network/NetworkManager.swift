import Foundation
import Combine

final class NetworkMaganer: NetworkProtocol {
    
    static let shared = NetworkMaganer()
    
    private var session = URLSession.shared
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func get() {}
    func put() {}
    func delete() {}
    
    func post<T, U>(body: T, path: String) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try? encoder.encode(body)

        let url = URL(string: Endpoint.authorization.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.post.rawValue
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder )
            .mapError { error -> NetworkError in
                return NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
