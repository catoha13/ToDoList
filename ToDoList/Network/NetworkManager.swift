import Foundation
import Combine

final class NetworkMaganer: NetworkProtocol {
    
    static let shared = NetworkMaganer()
    
    private var session = URLSession.shared
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func get<U>(path: String, header: String?) -> AnyPublisher<U, NetworkError> where U: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let url = URL(string: BaseUrl.authorization.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.get.rawValue
        
        if header != nil {
            request.setValue(header, forHTTPHeaderField: "Authorization")
        }
        return session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder )
            .mapError { error -> NetworkError in
                return NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    func put() {}
    func delete() {}
    
    func post<T, U>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try? encoder.encode(body)
        
       
        
        let url = URL(string: BaseUrl.authorization.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.post.rawValue
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if header != nil {
            request.setValue(header, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData!) as? [String: Any] {
                print(json)
            }
        } catch {
            print("error")
        }
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
