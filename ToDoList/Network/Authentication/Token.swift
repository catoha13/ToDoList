import SwiftUI
import Combine

final class Token {
    @AppStorage("token") var savedToken: String?
    @AppStorage("refreshToken") var refreshToken : String?
    @AppStorage("expireDate") var expireDate: Int?
    @AppStorage("tokenType") var tokenType: String?
    @AppStorage("isValid") var isValid: Bool = false
    
    var header: String {
      return (tokenType ?? "") + " " + (savedToken ?? "")
    }
    
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentDate: Int = Date().getCurrentDate()
    
    private var model: TokenData {
        TokenData(refreshToken: refreshToken)
    }
    
    private let refreshTokenRequest = PassthroughSubject<Void, Never>()
    
    init() {
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        expireDate.publisher
            .map {
                if self.currentDate >= trimExpireDate($0) {
                    isValid = false
                } else {
                    isValid = true
                }
            }
            .sink { [weak self] _ in
                if self?.isValid == false {
                    self?.refreshTokenRequest.send()
                }
            }
            .store(in: &cancellables)
        
        refreshTokenRequest
            .sink { [weak self] _ in
                self?.getNewToken()
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
    
    private func trimExpireDate(_ date: Int) -> Int {
        var stringDate = String(date)
        stringDate.removeLast(3)
        return Int(stringDate) ?? 0
    }
}
