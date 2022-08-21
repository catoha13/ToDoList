import Foundation

final class NetworkMaganer: NetworkProtocol {
    
    static let shared = NetworkMaganer()
    
    func get() {}
    func put() {}
    func delete() {}
    
    func post<T, U>(body: T, url: String, completion: @escaping (Result<U, Error>) -> ()) where U : Decodable, T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try? encoder.encode(body)
        
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = Method.POST.rawValue
            request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let decoder = JSONDecoder()
                let responseObject = try? decoder.decode(U.self, from: data)
                if let object = responseObject {
                    completion(.success(object))
                }
            }
            task.resume()
        }
    }
}
