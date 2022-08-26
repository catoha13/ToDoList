import Foundation
import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var avatar: String = ""
    
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    private lazy var model = Model(email: email, password: password, username: username)
    private lazy var publisher: AnyPublisher<SignUpResponceModel, NetworkError> = {
        authService.signUp(model: model)
    }()
    
    func signUp() {
        publisher
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
}
