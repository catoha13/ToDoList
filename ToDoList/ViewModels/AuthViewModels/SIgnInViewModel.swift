import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String = ""
    @Published var isPresented = false
    
    private let token = Token()
    private let user = User()
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    private var model: RequestBodyModel {
        return RequestBodyModel(email: email, password: password, username: email)
    }
    
    let signIn = PassthroughSubject<Void, Never>()
    
    init() {
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        signIn
            .sink { [weak self] _ in
                self?.signInRequest()
            }
            .store(in: &cancellables)
    }
    
    private func signInRequest() {
        authService.signIn(model: model)
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished:
                        return
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                }, receiveValue: { [weak self] item in
                    if item.data.message == nil {
                        self?.user.userId = item.data.userId ?? "no data"
                        self?.token.savedToken = item.data.accessToken ?? "no data"
                        self?.token.refreshToken = item.data.refreshToken ?? "no data"
                        self?.token.expireDate = item.data.expiresIn ?? 0
                        self?.token.tokenType = item.data.tokenType ?? "no data"
                        self?.isPresented.toggle()
                    } else {
                        self?.errorMessage = item.data.message ?? "no data"
                    }
                })
            .store(in: &cancellables)
    }
    
}
