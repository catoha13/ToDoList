import Combine
import SwiftUI

struct ProfileNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    private var header: String {
        (token.tokenType ?? "no data") + " " + (token.savedToken ?? "no data")
    }
    private var userId: String {
        user.userId ?? "no data"
    }
    
    func uploadUserAvatar(image: UIImage, imageName: String) -> AnyPublisher<ProfileResponseModel, NetworkError> {
        let path = Path.userAvatar.rawValue
        let params = [
            "file" : imageName,
            "user_id" : userId
        ] as [String : Any]
        
       return networkManager.uploadAvatar(path: path, header: header,image: image ,parameters: params)
    }
    
    func fetchUser() -> AnyPublisher<ProfileResponseModel,NetworkError> {
        let path = Path.fetchUser.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchUserStatistics() -> AnyPublisher<FetchUserStatisticsModel, NetworkError> {
        let path = Path.fetchUserStatistics.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
    
    func downloadUserAvatar(url: String) -> AnyPublisher<UIImage?, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: header)
    }
    
    func signOut(model: SignOutModel) -> AnyPublisher<SignOut, NetworkError> {
        let path = Path.signOut.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
}
