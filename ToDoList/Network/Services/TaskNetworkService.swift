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
    
    func createTask() {
        
    }
    
    func updateTask() {
        
    }
    
    func deleteTask() {
        
    }
    
    func fetchOneTask() {
        
    }
    
    func fetchProjectsTasks() {
        
    }
    
    func fetchUserTasks() {
        
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
    
    func taskMembersSearch() {
        
    }
    
    func deleteTaskComment() {
        
    }
    
    func uploadTaskCommentAttachment() {
        
    }
    
    func downloadCommentAttachment() {
        
    }
}
