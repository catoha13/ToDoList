import SwiftUI
import Combine

final class Token {
    @AppStorage("token") var savedToken: String?
    @AppStorage("refreshToken") var refreshToken : String?
    @AppStorage("expireDate") var expireDate: Int?
    @AppStorage("tokenType") var tokenType: String?
    
    var header: String {
      return (tokenType ?? "") + " " + (savedToken ?? "")
    }
    
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentDate: Int = Date().getCurrentDate()
    
    private var model: TokenData {
        TokenData(refreshToken: refreshToken)
    }
        
    init() {
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        expireDate.publisher
            .sink { [weak self] date in
                if self?.currentDate ?? 0 >= date.trimExpireDate() {
                    self?.getNewToken()
                }
            }
            .store(in: &cancellables)
    }
    
    private func getNewToken() {
        authService.refreshToken(model: model)
            .sink(receiveCompletion: { _ in
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
