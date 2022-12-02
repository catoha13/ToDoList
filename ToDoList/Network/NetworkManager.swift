import SwiftUI
import Combine

struct NetworkMaganer: NetworkProtocol {
    
    static let shared = NetworkMaganer()
    
    private var session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    
    func get<U>(path: String, header: String?) -> AnyPublisher<U, NetworkError> where U: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let url = URL(string: BaseUrl.baseUrl.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.get.rawValue
        
        if header != nil {
            request.setValue(header, forHTTPHeaderField: "Authorization")
        }
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    func put<T, U>(body: T, path: String, header: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try? encoder.encode(body)
        
        let url = URL(string: BaseUrl.baseUrl.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.put.rawValue
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(header, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    func delete<U>(path: String, header: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let url = URL(string: BaseUrl.baseUrl.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.delete.rawValue
        request.setValue(header, forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func post<T, U>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try? encoder.encode(body)
        
        let url = URL(string: BaseUrl.baseUrl.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.post.rawValue
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        if header != nil {
            request.setValue(header, forHTTPHeaderField: "Authorization")
        }
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func uploadAvatar<U>(path: String, header: String, image: UIImage?, parameters: [String : Any]) -> AnyPublisher<U, NetworkError> where U : Decodable {
        
        let url = URL(string: BaseUrl.baseUrl.rawValue + path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.post.rawValue
        request.setValue(header, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if image != nil {
            var data = Data()
            let userId = parameters["user_id"]
            let fileName = parameters["file"]
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(userId ?? "")".data(using: .utf8)!)
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName ?? "some picture")\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            
            let compressedImage = image?.jpegData(compressionQuality: 0.1) ?? Data()
            let imageData = UIImage(data: compressedImage)
            
            data.append(imageData?.pngData() ?? Data())
            
            request.setValue("\(String(describing: data.count))", forHTTPHeaderField: "Content-Length")
            request.httpBody = data
        }
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: U.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func downloadAvatar(path: String, header: String) -> AnyPublisher<UIImage?, NetworkError> {
        let url = URL(string: path)
        var request = URLRequest(url: url!)
        request.httpMethod = Method.get.rawValue
        request.setValue(header, forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .map {
                guard let image = UIImage(data:$0.data) else { return UIImage(named: "background")! }
                return image
            }
            .receive(on: RunLoop.main)
            .mapError { error -> NetworkError in
                NetworkError.requestFailed(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}



