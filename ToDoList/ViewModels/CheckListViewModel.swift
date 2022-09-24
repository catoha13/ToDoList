import Combine
import SwiftUI

final class CheckListViewModel: ObservableObject {
    @Published var checklistRequestArray: [ChecklistItemsRequest] = []
    @Published var checklistResponseArray: [ChecklistData] = []
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
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("create publisher – \(error)")
                }
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
    func fetchAllChecklists() {
        fetchAllChecklistsPublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] item in
                let array = item.data
                self?.checklistResponseArray = array.sorted(by: { first, second in
                    first.createdAt < second.createdAt
                })
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
