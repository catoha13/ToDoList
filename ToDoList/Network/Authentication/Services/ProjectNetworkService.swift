import Foundation
import Combine

final class ProjectNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    
    func createProject<T,U>(model: T, header: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.projects.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func fetchProjects<U>(header: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.fetchProjects.rawValue + (user.userId ?? "no data")
        return networkManager.get(path: path, header: header)
    }
    
    func updateProject<T, U>(model: T, header: String, projectId: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.projects.rawValue + "/" + projectId
        return networkManager.put(body: model, path: path, header: header)
    }
}
