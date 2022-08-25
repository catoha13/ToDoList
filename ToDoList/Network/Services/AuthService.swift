import Foundation
import Combine

final class AuthService {
    private let networkManager = NetworkMaganer.shared
    
    func signIn<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        let path = Path.signIn.rawValue
        return networkManager.post(body: model, path: path)
    }
    
    func signUp<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        let path = Path.signUp.rawValue
        return networkManager.post(body: model, path: path)
    }
}
