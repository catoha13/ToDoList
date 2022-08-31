import Foundation
import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var avatar: String = ""
    @Published var errorMessage: String = ""
    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var isCredentialsValid = false
    @Published var isPresented = false
    
    private var authService = AuthService()
    private var token = Token()
    private var cancellables = Set<AnyCancellable>()
    private var  model: RequestBodyModel {
        RequestBodyModel(email: email, password: password, username: username)
    }
    private  var publisher: AnyPublisher<SignUpResponceModel, NetworkError>  {
        authService.signUp(model: model)
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
        publisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    self.errorMessage = error.description
                }
            }, receiveValue: {
                if $0.data.message == nil {
                    self.token.savedToken = $0.data.userSession?.accessToken ?? "no data"
                    self.token.refreshToken = $0.data.userSession?.refreshToken ?? "no data"
                    self.token.expireDate = $0.data.userSession?.expiresIn ?? 0
                } else {
                    self.errorMessage = $0.data.message ?? "no data"
                }
            })
            .store(in: &cancellables)
    }
}



