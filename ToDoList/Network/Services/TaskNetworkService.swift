import Combine
import SwiftUI

final class TaskNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    private var header: String {
        (token.tokenType ?? "no data") + " " + (token.savedToken ?? "no data")
    }
    private var userId: String {
        user.userId ?? "no data"
    }
    
    func createTask<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.tasks.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func updateTask<T, U>(model: T, taskId: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.put(body: model, path: path, header: header)
    }
    
    func deleteTask<U>(taskId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneTask() {
        
    }
    
    func fetchProjectsTasks() {
        
    }
    
    func fetchUserTasks<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.userTasks.rawValue + userId 
        return networkManager.get(path: path, header: header)
    }
    
    func fetchAssignToTasks() {
        
    }
    
    func fetchParticipateInTasks() {
        
    }
    
    func uploadTaskAttachment() {
        
    }
    
    func downloadTaskAttachment() {
        
    }
    
    func createTaskComment<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.comments.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func fetchTaskComments<U>(taskId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.taskComments.rawValue + taskId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchTaskComponents() {
        
    }
    
    func taskMembersSearch<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.membersSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func downloadMembersAvatars(url: String) -> AnyPublisher<UIImage?, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: header)
    }
    
    func projectsSearch<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.projectSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func deleteTaskComment<U>(commentId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.comments.rawValue + "/" + commentId
        return networkManager.delete(path: path, header: header)
    }
    
    func uploadTaskCommentAttachment() {
        
    }
    
    func downloadCommentAttachment() {
        
    }
}
