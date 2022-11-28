import Combine
import SwiftUI

struct TaskNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    func createTask(model: CreateTaskModel) -> AnyPublisher<TaskResponseModel, NetworkError> {
        let path = Path.tasks.rawValue
        return networkManager.post(body: model, path: path, header: token.header)
    }
    
    func updateTask(model: CreateTaskModel, taskId: String) -> AnyPublisher<TaskResponseModel, NetworkError> {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.put(body: model, path: path, header: token.header)
    }
    
    func deleteTask(taskId: String) -> AnyPublisher<DeleteTaskModel, NetworkError> {
        let path = Path.tasks.rawValue + "/" + taskId
        return networkManager.delete(path: path, header: token.header)
    }
    
    func fetchOneTask() {
        
    }
    
    func fetchProjectsTasks() {
        
    }
    
    func fetchUserTasks() -> AnyPublisher<FetchTasks, NetworkError> {
        let path = Path.userTasks.rawValue + user.id
        return networkManager.get(path: path, header: token.header)
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
        return networkManager.post(body: model, path: path, header: token.header)
    }
    
    func fetchTaskComments(taskId: String) -> AnyPublisher<FetchComments, NetworkError> {
        let path = Path.taskComments.rawValue + taskId
        return networkManager.get(path: path, header: token.header)
    }
    
    func fetchTaskComponents() {
        
    }
    
    func taskMembersSearch() -> AnyPublisher<SearchUsers, NetworkError> {
        let path = Path.membersSearch.rawValue
        return networkManager.get(path: path, header: token.header)
    }
    
    func downloadMembersAvatars(url: String) -> AnyPublisher<UIImage?, NetworkError> {
        let path = url
        return networkManager.downloadAvatar(path: path, header: token.header)
    }
    
    func projectsSearch() -> AnyPublisher<SearchProjects, NetworkError> {
        let path = Path.projectSearch.rawValue
        return networkManager.get(path: path, header: token.header)
    }
    
    func deleteTaskComment(commentId: String) -> AnyPublisher<DeleteCommentModel, NetworkError> {
        let path = Path.comments.rawValue + "/" + commentId
        return networkManager.delete(path: path, header: token.header)
    }
    
    func uploadTaskCommentAttachment() {
        
    }
    
    func downloadCommentAttachment() {
        
    }
}
