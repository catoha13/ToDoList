import Combine

final class ProfileNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    private var header: String {
        (token.tokenType ?? "no data") + " " + (token.savedToken ?? "no data")
    }
    private var userId: String {
        user.userId ?? "no data"
    }
    
    func uploadUserAvatar() {
        
    }
    
    func fetchUser<U>() -> AnyPublisher<U,NetworkError> where U: Decodable {
        let path = Path.fetchUser.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchUserStatistics<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.fetchUserStatistics.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
    
    func downloadUserAvatar<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.userAvatar.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
}
