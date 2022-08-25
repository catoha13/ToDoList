import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    
    private var authService = AuthService()
    
    private lazy var model = Model(email: username, password: password, username: username)
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var publisher: AnyPublisher<SignInResponceModel, NetworkError> = {
        authService.signIn(model: model)
    }()
    
    func signIn() {
        publisher
            .sink(
                receiveCompletion: {
                print($0)
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
    
}
