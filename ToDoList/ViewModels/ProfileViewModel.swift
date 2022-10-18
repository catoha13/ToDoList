import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    @Published var username = " "
    @Published var email = " "
    @Published var avatarUrl = ""
    @Published var createdTask = 0
    @Published var completedTask = 0
    @Published var eventsPercentage = ""
    @Published var quickNotesPercentage = ""
    @Published var toDotsPercentage = ""
    @Published var eventsProgress = 0.0
    @Published var quickNoteProgress = 0.0
    @Published var toDoProgress = 0.0
    
    private var profileService = ProfileNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var fetchUserRequest: AnyPublisher<ProfileResponseModel, NetworkError> {
        return profileService.fetchUser()
    }
    private var fetchUserStatisticsRequest: AnyPublisher<FetchUserStatisticsModel, NetworkError> {
        return profileService.fetchUserStatistics()
    }
    private var downloadAvatarRequest: AnyPublisher<ProfileResponseModel, NetworkError> {
        return profileService.downloadUserAvatar()
    }
    
    init() {
        fetchUser()
        fetchStatistics()
    }
    
    private func fetchUser() {
        fetchUserRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.username = item.data.username ?? ""
                self?.email = item.data.email ?? ""
                self?.avatarUrl = item.data.avatarUrl ?? ""
                print(self!.avatarUrl)
                self?.downloadAvatar()
            })
            .store(in: &cancellables)
    }
    
    private func fetchStatistics() {
        fetchUserStatisticsRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.createdTask = item.data.createdTasks ?? 0
                self?.completedTask = item.data.completedTasks ?? 0
                self?.eventsPercentage = item.data.events ?? ""
                self?.quickNotesPercentage = item.data.quickNotes ?? ""
                self?.toDotsPercentage = item.data.todo ?? ""
                self?.eventsProgress = self?.convertProgress(percentage: item.data.events ?? "") ?? 0.0
                self?.quickNoteProgress = self?.convertProgress(percentage: item.data.quickNotes ?? "") ?? 0.0
                self?.toDoProgress = self?.convertProgress(percentage: item.data.todo ?? "") ?? 0.0
            })
            .store(in: &cancellables)
    }
    
    private func downloadAvatar() {
        downloadAvatarRequest
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] item in
                
            })
            .store(in: &cancellables)
    }
    
    private func convertProgress(percentage: String) -> Double {
        var string = percentage
        if string.isEmpty {
        } else {
            string.removeLast()
        }
        let number = Double(string)
        return (number ?? 0.4) / 100
    }
}
