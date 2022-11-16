import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    //MARK: Profile View
    @Published var username = " "
    @Published var email = " "
    @Published var avatarUrl: String? = ""
    @Published var avatarImage: UIImage? = UIImage(named: "background")!
    @Published var createdTask = 0
    @Published var completedTask = 0
    @Published var eventsPercentage = ""
    @Published var quickNotesPercentage = ""
    @Published var toDotsPercentage = ""
    @Published var eventsProgress = 0.0
    @Published var quickNoteProgress = 0.0
    @Published var toDoProgress = 0.0
    @Published var alertMessage = ""
    
    @Published var showSetting = false
    @Published var isSignedOut = false
    @Published var showImagePicker = false
    @Published var showNetworkAlert = false
    
    private let profileService = ProfileNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Model
    private var signOutModel: SignOutModel {
        SignOutModel(email: email)
    }
    
    //MARK: Publishers
    let fetchUserData = PassthroughSubject<Void, Never>()
    let fetchUserStatistics = PassthroughSubject<Void, Never>()
    let downloadAvatar = PassthroughSubject<Void, Never>()
    let uploadAvatar = PassthroughSubject<Void, Never>()
    let signOut = PassthroughSubject<Void, Never>()
    
    init() {
        addSubscriptions()
        fetchUserData.send()
    }
    
    //MARK: Funcs
    private func addSubscriptions() {
        fetchUserData
            .sink { [weak self] _ in
                self?.fetchUser()
                self?.fetchUserStatistics.send()
            }
            .store(in: &cancellables)
        
        fetchUserStatistics
            .sink { [weak self] _ in
                self?.fetchStatistics()
            }
            .store(in: &cancellables)
        
        downloadAvatar
            .sink { [weak self] _ in
                self?.downloadAvatarRequest()
            }
            .store(in: &cancellables)
        
        uploadAvatar
            .sink { [weak self] _ in
                self?.uploadAvatarRequest()
            }
            .store(in: &cancellables)
        
        signOut
            .sink { [weak self] _ in
                self?.signOutRequest()
            }
            .store(in: &cancellables)
        
    }
    
    private func fetchUser() {
        profileService.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.username = item.data.username ?? ""
                self?.email = item.data.email ?? ""
                self?.avatarUrl = item.data.avatarUrl ?? ""
                self?.downloadAvatarRequest()
            })
            .store(in: &cancellables)
    }
    
    private func fetchStatistics() {
        profileService.fetchUserStatistics()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
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
    
    private func downloadAvatarRequest() {
        profileService.downloadUserAvatar(url: avatarUrl ?? "")
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.avatarImage = item ?? UIImage(named: "background")!
            })
            .store(in: &cancellables)
    }
    
    private func uploadAvatarRequest() {
        profileService.uploadUserAvatar(image: avatarImage!, imageName: avatarUrl!)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            },
                  receiveValue: { [weak self] item in
                if item.data.message != nil {
                    self?.alertMessage = item.data.message ?? ""
                    self?.showNetworkAlert = true
                }
            })
            .store(in: &cancellables)
    }
    
    func signOutRequest() {
        profileService.signOut(model: signOutModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.isSignedOut.toggle()
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
