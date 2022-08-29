import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String = ""
    @Published var credentialsChecked = false
    
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
                    print($0)
                    switch $0 {
                    case .finished:
                        return
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                }, receiveValue: {
                    print("Value \($0)")
                    if $0.data.message == nil {
                        self.credentialsChecked = true
                    } else {
                        self.errorMessage = $0.data.message ?? "no data"
                    }
                })
            .store(in: &cancellables)
    }
    
}
