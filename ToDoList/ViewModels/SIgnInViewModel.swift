import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String = ""
    @Published var credentialsChecked = false
    
    private var token = Token()
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    private var model: RequestBodyModel {
        return RequestBodyModel(email: email, password: password, username: email)
    }
    private var publisher: AnyPublisher<SignInResponceModel, NetworkError> {
        authService.signIn(model: model)
    }
    
    func signIn() {
        publisher
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished:
                        return
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                }, receiveValue: {
                    if $0.data.message == nil {
                        self.token.savedToken = $0.data.accessToken ?? "no data"
                        self.token.refreshToken = $0.data.refreshToken ?? "no data"
                        self.token.expireDate = $0.data.expiresIn ?? 0
                        self.token.checkToken
                            .sink { self.credentialsChecked = $0
                            }
                            .store(in: &self.cancellables)
                    } else {
                        self.errorMessage = $0.data.message ?? "no data"
                    }
                })
            .store(in: &cancellables)
    }
    
}
