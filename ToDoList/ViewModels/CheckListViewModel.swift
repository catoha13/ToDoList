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
     var updateModel: ChecklistRequestModel {
        return ChecklistRequestModel(title: title, color: color, ownerId: ownerId, items: updateItemsModel)
    }
    private var requestModel: ChecklistRequestModel {
        return ChecklistRequestModel(title: title, color: color, ownerId: ownerId, items: checklistRequestArray)
    }
    
    private var createChecklistPublisher: AnyPublisher<ChecklistRequestModel, NetworkError> {
        return networkService.createChecklist(model: requestModel)
    }
    
    private var updateChecklistPublisher: AnyPublisher<ChecklistResponseModel, NetworkError> {
        return networkService.updateChecklist(model: updateModel, checklistId: checklistId)
    }
    
    private var fetchAllChecklistsPublisher: AnyPublisher<FetchAllChecklistsModel, NetworkError> {
        return networkService.fetchAllChecklists()
    }
    
    func createChecklist() {
        createChecklistPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func updateChecklist() {
        updateChecklistPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllChecklists()
            })
            .store(in: &cancellables)
    }
    
    func fetchAllChecklists() {
        fetchAllChecklistsPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                let array = item.data
                self?.checklistResponseArray = array.sorted(by: { first, second in
                    first.createdAt < second.createdAt
                })
                self?.checklistResponseItems = item.data.first?.items ?? []
            })
            .store(in: &cancellables)
    }
    
    func convertColor(color: Color) -> String {
        var stringColor = color.description
        stringColor.removeLast()
        stringColor.removeLast()
        return stringColor
    }
}
