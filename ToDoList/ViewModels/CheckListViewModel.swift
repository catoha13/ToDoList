import Combine

final class CheckListViewModel: ObservableObject {
    @Published var checkListArray = [
        CheckListItem(title: "")
    ]
    @Published var title = ""
    @Published var color = ""
    
    private var checklistNetworkService = CheckListNetworkService()
    private var user = User()
    private var cancellables = Set<AnyCancellable>()

    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    
    
    
    
    private var fetchAllChecklistsPublisher: AnyPublisher<FetchAllChecklistsModel, NetworkError> {
        return checklistNetworkService.fetchAllChecklists()
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
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
}
