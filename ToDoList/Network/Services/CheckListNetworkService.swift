import Combine
import SwiftUI

struct CheckListNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    private var header: String {
        (token.tokenType ?? "no data") + " " + (token.savedToken ?? "no data")
    }
    private var userId: String {
        user.userId ?? "no data"
    }
    
    func createChecklist(model: ChecklistUpdateRequestModel) -> AnyPublisher<ChecklistUpdateRequestModel, NetworkError> {
        let path = Path.checklists.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func updateChecklist(model: ChecklistUpdateRequestModel, checklistId: String) -> AnyPublisher<ChecklistResponseModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.put(body: model, path: path, header: header)
    }
    
    func deleteChecklistItem(checklistItemId: String) -> AnyPublisher<DeleteChecklistData, NetworkError> {
        let path = Path.checklistsItems.rawValue + "/" + checklistItemId
        return networkManager.delete(path: path, header: header)
    }
    
    func deleteChecklist(checklistId: String) -> AnyPublisher<DeleteChecklistModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneChecklist(checklistId: String) -> AnyPublisher<ChecklistResponseModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchAllChecklists() -> AnyPublisher<FetchAllChecklistsResponseModel, NetworkError> {
        let path = Path.usersChecklists.rawValue + userId
        return networkManager.get(path: path, header: header)
    }
}
