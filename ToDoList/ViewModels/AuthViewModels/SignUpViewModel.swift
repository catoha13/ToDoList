import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var isPresented = false
    @Published var avatar: UIImage? = nil
    @Published var url: String? = nil
    
    @Published var alertMessage = ""
    @Published var showNetworkAlert = false
    
    private let authService = AuthService()
    private let profileService = ProfileNetworkService()
    private let userCoreDataManager = UserCoreDataManager()
    private let token = Token()
    private let user = User()
    
    private var cancellables = Set<AnyCancellable>()
    private var model: RequestBodyModel {
        .init(email: email, password: password.toBase64(), username: username)
    }
    
    private let fetchUserData = PassthroughSubject<Void, Never>()
    private let uploadAvatar = PassthroughSubject<Void, Never>()
    let signUp = PassthroughSubject<Void, Never>()
        
    init() {
        addSubscriptions()
        user.readPassword()
    }
    
    private func addSubscriptions() {
        signUp
            .sink { [weak self] _ in
                self?.signUpRequest()
            }
            .store(in: &cancellables)
        
        uploadAvatar
            .sink { [weak self] _ in
                self?.uploadAvatarRequest()
            }
            .store(in: &cancellables)
        
        fetchUserData
            .sink { [weak self] _ in
                self?.fetchUserDataRequest()
            }
            .store(in: &cancellables)
    }
    
    private func signUpRequest() {
        authService.signUp(model: model)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }, receiveValue: { [weak self] item in
                guard let self = self else { return }
                if item.data.message == nil {
                    self.user.id = item.data.id ?? ""
                    self.user.email = item.data.email ?? ""
                    self.user.password = self.password.toBase64()
                    self.user.savePassword()
                    self.token.accessToken = item.data.userSession?.accessToken.toBase64() ?? ""
                    self.token.refreshToken = item.data.userSession?.refreshToken.toBase64() ?? ""
                    self.token.expireDate = item.data.userSession?.expiresIn ?? 0
                    self.token.tokenType = item.data.userSession?.tokenType ?? ""
                    self.token.saveToken()
                    self.token.saveRefreshToken()
                    self.uploadAvatar.send()
                    self.fetchUserData.send()
                    self.isPresented.toggle()
                } else {
                    self.errorMessage = item.data.message ?? ""
                }
            })
            .store(in: &cancellables)
    }
    
    private func uploadAvatarRequest() {
        profileService.uploadUserAvatar(image: (avatar ?? UIImage(named: "background"))!,
                                        imageName: url ?? "")
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
    
    private func fetchUserDataRequest() {
        profileService.fetchUser()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            } receiveValue: { [weak self] item in
                guard let self = self else { return }
                self.userCoreDataManager.saveUser(newUser: item.data)
            }
            .store(in: &cancellables)
        
    }
    
}



