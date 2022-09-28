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
    
    func createChecklist<T, U>(model: T) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.checklists.rawValue
        return networkManager.post(body: model, path: path, header: header, parameters: nil)
    }
    
    func updateChecklist<T, U>(model: T, checklistId: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.put(body: model, path: path, header: header)
    }
    
    func deleteChecklistItem<U>(checklistItemId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.checklistsItems.rawValue + "/" + checklistItemId
        return networkManager.delete(path: path, header: header)
    }
    
    func deleteChecklistItems() {
        
    }
    
    func deleteChecklist<U>(checklistId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneChecklist() {
        
    }
    
    func fetchAllChecklists<U>() -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.usersChecklists.rawValue + "/" + userId
        return networkManager.get(path: path, header: header)
    }
}
