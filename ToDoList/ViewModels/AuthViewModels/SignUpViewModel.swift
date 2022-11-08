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
    
    private var authService = AuthService()
    private var profileService = ProfileNetworkService()
    private var token = Token()
    private var user = User()
    
    private var cancellables = Set<AnyCancellable>()
    private var  model: RequestBodyModel {
        RequestBodyModel(email: email, password: password, username: username)
    }
    private  var signUpRequest: AnyPublisher<SignUpResponceModel, NetworkError>  {
        authService.signUp(model: model)
    }
    
    private var uploadAvatarRequest: AnyPublisher<ProfileResponseModel, NetworkError> {
        return profileService.uploadUserAvatar(image: (avatar ?? UIImage(named: "background"))!,
                                               imageName: url ?? "")
    }
    
    let emailFormat = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    let passwordFormat = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")

    init() {
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
    }
    
    func signUp() {
        signUpRequest
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    self.errorMessage = error.description
                }
                print($0)
            }, receiveValue: { [weak self] item in
                if item.data.message == nil {
                    self?.isPresented.toggle()
                    self?.token.savedToken = item.data.userSession?.accessToken ?? "no data"
                    self?.token.refreshToken = item.data.userSession?.refreshToken ?? "no data"
                    self?.token.expireDate = item.data.userSession?.expiresIn ?? 0
                    self?.token.tokenType = item.data.userSession?.tokenType
                    self?.user.userId = item.data.id ?? "no data"
                    self?.user.savedEmail = item.data.email ?? "no data"
                } else {
                    self?.errorMessage = item.data.message ?? "no data"
                }
            })
            .store(in: &cancellables)
    }
    
    func uploadAvatar() {
        uploadAvatarRequest
            .sink(receiveCompletion: { _ in
            },
                  receiveValue: { _ in
            })
            .store(in: &cancellables)
    }
    
}



