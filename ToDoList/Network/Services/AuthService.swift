import Foundation
import Combine

struct AuthService {
    private let networkManager = NetworkMaganer.shared
    
    func signIn(model: RequestBodyModel) -> AnyPublisher<SignInResponceModel, NetworkError> {
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
