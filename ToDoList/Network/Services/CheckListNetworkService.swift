import Combine
import SwiftUI

final class CheckListNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    private var header: String {
        (token.tokenType ?? "no data") + " " + (token.savedToken ?? "no data")
    }
    private var userId: String {
        user.userId ?? "no data"
    }
    
    func createChecklist() {
        
    }
    
    func updateChecklist() {
        
    }
    
    func deleteChecklistItem() {
        
    }
    
    func deleteChecklistItems() {
        
    }
    
    func deleteChecklist() {
        
    }
    
    func fetchOneChecklist() {
        
    }
    
    func fetchAllChecklists<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.usersChecklists.rawValue + "/" + userId
        return networkManager.get(path: path, header: header)
    }
}
