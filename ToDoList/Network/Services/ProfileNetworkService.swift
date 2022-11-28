import Combine
import SwiftUI

struct ProfileNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    func uploadUserAvatar(image: UIImage, imageName: String) -> AnyPublisher<ProfileResponseModel, NetworkError> {
        let path = Path.userAvatar.rawValue
        let params = [
            "file" : imageName,
            "user_id" : user.id
        ] as [String : Any]
        
       return networkManager.uploadAvatar(path: path, header: token.header,image: image ,parameters: params)
    }
    
    func fetchUser() -> AnyPublisher<ProfileResponseModel,NetworkError> {
        let path = Path.fetchUser.rawValue + user.id
        return networkManager.get(path: path, header: token.header)
    }
    
    func fetchUserStatistics() -> AnyPublisher<FetchUserStatisticsModel, NetworkError> {
        let path = Path.fetchUserStatistics.rawValue + user.id
        return networkManager.get(path: path, header: token.header)
    }
    
    func downloadUserAvatar(url: String) -> AnyPublisher<UIImage?, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: token.header)
    }
    
    func signOut(model: SignOutModel) -> AnyPublisher<SignOut, NetworkError> {
        let path = Path.signOut.rawValue
        return networkManager.post(body: model, path: path, header: token.header)
    }
}
