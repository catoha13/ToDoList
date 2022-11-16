import Foundation
import Combine

final class AuthService {
    private let networkManager = NetworkMaganer.shared
    
    func signIn<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T : Encodable, U : Decodable {
        let path = Path.signIn.rawValue
        return networkManager.post(body: model, path: path, header: nil)
    }
    
    func signUp(model: RequestBodyModel) -> AnyPublisher<SignUpResponceModel, NetworkError> {
        let path = Path.signUp.rawValue
        return networkManager.post(body: model, path: path, header: nil)
    }
    
    func refreshToken(model: TokenData) -> AnyPublisher<RefreshTokenModel, NetworkError> {
        let path = Path.refreshToken.rawValue
        return networkManager.post(body: model, path: path, header: nil)
    }
}
