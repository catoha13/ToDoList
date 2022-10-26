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
    
    func updateTask() {
        
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
    
    func createTaskComment() {
        
    }
    
    func fetchTaskComponents() {
        
    }
    
    func taskMembersSearch<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.membersSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func downloadMembersAvatars(url: String) -> AnyPublisher<UIImage, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: header)
    }
    
    func projectsSearch<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.projectSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func deleteTaskComment() {
        
    }
    
    func uploadTaskCommentAttachment() {
        
    }
    
    func downloadCommentAttachment() {
        
    }
}
