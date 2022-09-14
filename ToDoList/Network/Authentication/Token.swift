import Foundation
import SwiftUI
import Combine

final class Token: ObservableObject {
    @AppStorage("token") var savedToken: String?
    @AppStorage("refreshToken") var refreshToken : String?
    @AppStorage("expireDate") var expireDate: Int?
    @AppStorage("tokenType") var tokenType: String?
    
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentDate: Int = {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let date = Int(timeInterval)
        return date
    }()
    
    private var model: TokenData {
        TokenData(refreshToken: refreshToken)
    }
    
    private var publisher: AnyPublisher<RefreshTokenModel, NetworkError> {
        authService.refreshToken(model: model)
    }
    
    var checkToken: AnyPublisher<Bool, Never> {
        expireDate.publisher
            .map {
                if self.currentDate >= $0 {
                    getNewToken()
                    return false
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func getNewToken() {
        publisher
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                if $0.data.message == nil {
                    self.savedToken = $0.data.accessToken ?? "no data"
                    self.refreshToken = $0.data.refreshToken ?? "no data"
                    self.expireDate = $0.data.expiresIn ?? 0
                }
            })
            .store(in: &cancellables)
    }
}
