import Combine
import SwiftUI

final class CheckListViewModel: ObservableObject {
    @Published var checklistRequestArray: [ChecklistItemsModel] = []
    @Published var checklistResponseArray: [ChecklistData] = []
    @Published var checklistResponseItems: [ChecklistItemsModel] = []
    @Published var title = ""
    @Published var color = ""
    @Published var itemId = ""
    @Published var newItemContent = ""
    @Published var isCompleted = false
    @Published var checklistId = ""
    
    private var networkService = CheckListNetworkService()
    private var user = User()
    private var cancellables = Set<AnyCancellable>()

    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var updateItemsModel: [ChecklistItemsModel] {
        return [ChecklistItemsModel(id: itemId,content: newItemContent, isCompleted: isCompleted)]
    }
    private var updateModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: updateItemsModel)
    }
    private var editChecklistModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistResponseItems)
    }
    private var requestModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistRequestArray)
    }
    
    private var createChecklistRequest: AnyPublisher<ChecklistUpdateRequestModel, NetworkError> {
        return networkService.createChecklist(model: requestModel)
    }
    
    private var updateChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        return networkService.updateChecklist(model: updateModel, checklistId: checklistId)
    }
    private var editChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        return networkService.updateChecklist(model: editChecklistModel, checklistId: checklistId)
    }
    
    private var deleteChecklistItemRequest: AnyPublisher<DeleteChecklistData, NetworkError> {
        return networkService.deleteChecklistItem(checklistItemId: itemId)
    }
    
    private var deleteChecklistRequest: AnyPublisher<DeleteChecklistModel, NetworkError> {
        return networkService.deleteChecklist(checklistId: checklistId)
    }
    
    private var fetchAllChecklistsRequest: AnyPublisher<FetchAllChecklistsModel, NetworkError> {
        return networkService.fetchAllChecklists()
    }
    
    func createChecklist() {
        createChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func updateChecklist() {
        updateChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func editChecklist() {
        editChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func deleteChecklist() {
        deleteChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.updateChecklist()
            })
            .store(in: &cancellables)
    }
    
    func deleteCheclistItem() {
        deleteChecklistItemRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func fetchAllChecklists() {
        fetchAllChecklistsRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                let array = item.data
                self?.checklistResponseArray = array.sorted(by: { first, second in
                    first.createdAt > second.createdAt
                })
                self?.checklistResponseItems = item.data.first?.items ?? []
            })
            .store(in: &cancellables)
    }
}
