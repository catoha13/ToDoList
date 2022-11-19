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
    @Published var isOffline = false
    
    private let profileService = ProfileNetworkService()
    private let userCoreDataManager = UserCoreDataManager()
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
    
    //MARK: Initializer
    init() {
        addSubscriptions()
        fetchUserData.send()
    }
    
    //MARK: Add Subscriptions
    private func addSubscriptions() {
        fetchUserData
            .sink { [weak self] _ in
                self?.fetchUserDataRequest()
                self?.fetchUserStatistics.send()
            }
            .store(in: &cancellables)
        
        fetchUserStatistics
            .sink { [weak self] _ in
                self?.fetchStatisticsRequest()
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
    
    //MARK: Fetch User Data
    private func fetchUserDataRequest() {
        profileService.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    guard let self = self else { return }
                    self.alertMessage = error.description
                    self.isOffline = true
                    self.username = self.userCoreDataManager.loadUser().username ?? ""
                    self.email = self.userCoreDataManager.loadUser().email ?? ""
                }
            }, receiveValue: { [weak self] item in
                guard let self = self else { return }
                self.userCoreDataManager.saveUser(newUser: item.data)
                self.username = item.data.username ?? ""
                self.email = item.data.email ?? ""
                self.avatarUrl = item.data.avatarUrl ?? ""
                self.downloadAvatarRequest()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Fetch User Statistics
    private func fetchStatisticsRequest() {
        profileService.fetchUserStatistics()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    guard let self = self else { return }
                    self.alertMessage = error.description
                    self.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                guard let self = self else { return }
                self.createdTask = item.data.createdTasks ?? 0
                self.completedTask = item.data.completedTasks ?? 0
                self.eventsPercentage = item.data.events ?? ""
                self.quickNotesPercentage = item.data.quickNotes ?? ""
                self.toDotsPercentage = item.data.todo ?? ""
                self.eventsProgress = self.convertProgress(percentage: item.data.events ?? "")
                self.quickNoteProgress = self.convertProgress(percentage: item.data.quickNotes ?? "")
                self.toDoProgress = self.convertProgress(percentage: item.data.todo ?? "")
            })
            .store(in: &cancellables)
    }
    
    //MARK: Download Avatar
    private func downloadAvatarRequest() {
        profileService.downloadUserAvatar(url: avatarUrl ?? "")
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                self?.avatarImage = item ?? UIImage(named: "background")!
            })
            .store(in: &cancellables)
    }
    
    //MARK: Upload Avatar
    private func uploadAvatarRequest() {
        profileService.uploadUserAvatar(image: avatarImage!, imageName: avatarUrl!)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            },
                  receiveValue: { [weak self] item in
                if item.data.message != nil {
                    self?.alertMessage = item.data.message ?? ""
                    self?.isOffline = true
                }
            })
            .store(in: &cancellables)
    }
    
    //MARK: Sign Out
    private func signOutRequest() {
        profileService.signOut(model: signOutModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
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
