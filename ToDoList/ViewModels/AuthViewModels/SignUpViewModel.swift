import Foundation
import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var isCredentialsValid = false
    @Published var isPresented = false
    @Published var avatar : UIImage? = nil
    @Published var url: String? = nil
    
    private let authService = AuthService()
    private let profileService = ProfileNetworkService()
    private let token = Token()
    private let user = User()
    
    private var cancellables = Set<AnyCancellable>()
    private var model: RequestBodyModel {
        RequestBodyModel(email: email, password: password, username: username)
    }
    
    let signUp = PassthroughSubject<Void, Never>()
    private let uploadAvatar = PassthroughSubject<Void, Never>()
    
    private let emailFormat = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    private let passwordFormat = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")

    init() {
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        
        $email
            .map { email in
                return self.emailFormat.evaluate(with: email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)
        $password
            .map { password in
                return self.passwordFormat.evaluate(with: password)
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($isEmailValid, $isPasswordValid)
            .map { isEmailValid, isPasswordValid in
                return ( isEmailValid && isPasswordValid)
            }
            .assign(to: \.isCredentialsValid, on: self)
            .store(in: &cancellables)
        
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
                    self.token.savedToken = item.data.userSession?.accessToken ?? "no data"
                    self.token.refreshToken = item.data.userSession?.refreshToken ?? "no data"
                    self.token.expireDate = item.data.userSession?.expiresIn ?? 0
                    self.token.tokenType = item.data.userSession?.tokenType
                    self.user.userId = item.data.id ?? "no data"
                    self.user.savedEmail = item.data.email ?? "no data"
                    self.uploadAvatar.send()
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
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
}



