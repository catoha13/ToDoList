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
    
    func createTask(model: CreateTaskModel) -> AnyPublisher<TaskResponseModel, NetworkError> {
        let path = Path.tasks.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func updateTask(model: CreateTaskModel, taskId: String) -> AnyPublisher<TaskResponseModel, NetworkError> {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.put(body: model, path: path, header: header)
    }
    
    func deleteTask(taskId: String) -> AnyPublisher<DeleteTaskModel, NetworkError> {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneTask() {
        
    }
    
    func fetchProjectsTasks() {
        
    }
    
    func fetchUserTasks() -> AnyPublisher<FetchTasks, NetworkError> {
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
    
    func createTaskComment(model: CreateCommentModel) -> AnyPublisher<FetchComments, NetworkError> {
        let path = Path.comments.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func fetchTaskComments(taskId: String) -> AnyPublisher<FetchComments, NetworkError> {
        let path = Path.taskComments.rawValue + taskId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchTaskComponents() {
        
    }
    
    func taskMembersSearch() -> AnyPublisher<SearchUsers, NetworkError> {
        let path = Path.membersSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func downloadMembersAvatars(url: String) -> AnyPublisher<UIImage?, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: header)
    }
    
    func projectsSearch() -> AnyPublisher<SearchProjects, NetworkError> {
        let path = Path.projectSearch.rawValue
        return networkManager.get(path: path, header: header)
    }
    
    func deleteTaskComment(commentId: String) -> AnyPublisher<DeleteCommentModel, NetworkError> {
        let path = Path.comments.rawValue + "/" + commentId
        return networkManager.delete(path: path, header: header)
    }
    
    func uploadTaskCommentAttachment() {
        
    }
    
    func downloadCommentAttachment() {
        
    }
}
