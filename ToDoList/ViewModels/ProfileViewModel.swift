import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var avatarUrl = "superhero"
    @Published var createdTask = 2
    @Published var completedTask = 13
    
    private var profileService = ProfileNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var fetchUserPublisher: AnyPublisher<ProfileResponseModel, NetworkError> {
        return profileService.fetchUser()
    }
    private var fetchUserStatisticsPublisher: AnyPublisher<FetchUserStatisticsModel, NetworkError> {
        return profileService.fetchUserStatistics()
    }
    
    func fetchUser() {
        fetchUserPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.username = item.data.username ?? ""
                self?.email = item.data.email ?? ""
                self?.avatarUrl = item.data.avatarUrl ?? ""
            })
            .store(in: &cancellables)
    }
    
    func fetchStatistics() {
        fetchUserStatisticsPublisher
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
