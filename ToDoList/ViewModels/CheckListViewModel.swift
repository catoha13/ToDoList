import Combine
import SwiftUI

final class CheckListViewModel: ObservableObject {
    @Published var checklistRequestArray: [ChecklistItemsRequest] = []
    @Published var checklistResponseArray: [ChecklistData] = []
    @Published var checklistItems: [ChecklistItemsModel] = []
    @Published var title = ""
    @Published var color = ""
    
    private var networkService = CheckListNetworkService()
    private var user = User()
    private var cancellables = Set<AnyCancellable>()

    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var requestModel: ChecklistRequestModel {
        return ChecklistRequestModel(title: title, color: color, ownerId: ownerId, items: checklistRequestArray)
    }
    private var createChecklistPublisher: AnyPublisher<ChecklistRequestModel, NetworkError> {
        return networkService.createChecklist(model: requestModel)
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
    
    func fetchAllChecklists() {
        fetchAllChecklistsPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                let array = item.data
                self?.checklistResponseArray = array.sorted(by: { first, second in
                    first.createdAt < second.createdAt
                })
                self?.checklistItems = item.data.first?.items ?? []
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
