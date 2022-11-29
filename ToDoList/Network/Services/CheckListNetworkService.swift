import Combine
import SwiftUI

struct CheckListNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    func createChecklist(model: ChecklistUpdateRequestModel) -> AnyPublisher<ChecklistUpdateRequestModel, NetworkError> {
        let path = Path.checklists.rawValue
        return networkManager.post(body: model, path: path, header: token.header)
    }
    
    func updateChecklist(model: ChecklistUpdateRequestModel, checklistId: String) -> AnyPublisher<ChecklistResponseModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.put(body: model, path: path, header: token.header)
    }
    
    func deleteChecklistItem(checklistItemId: String) -> AnyPublisher<DeleteChecklistData, NetworkError> {
        let path = Path.checklistsItems.rawValue + "/" + checklistItemId
        return networkManager.delete(path: path, header: token.header)
    }
    
    func deleteChecklist(checklistId: String) -> AnyPublisher<DeleteChecklistModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.delete(path: path, header: token.header)
    }
    
    func fetchOneChecklist(checklistId: String) -> AnyPublisher<ChecklistResponseModel, NetworkError> {
        let path = Path.checklists.rawValue + "/" + checklistId
        return networkManager.get(path: path, header: token.header)
    }
    
    func fetchAllChecklists() -> AnyPublisher<FetchAllChecklistsResponseModel, NetworkError> {
        let path = Path.usersChecklists.rawValue + user.id
        return networkManager.get(path: path, header: token.header)
    }
}
