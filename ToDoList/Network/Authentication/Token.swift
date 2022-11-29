import SwiftUI
import Combine

final class Token {
    @Published var accessToken: String = ""
    @Published var refreshToken : String = ""
    @AppStorage("expireDate") var expireDate: Int = 0
    @AppStorage("tokenType") var tokenType: String = ""
    
    private var authService = AuthService()
    private let keychain = KeychainManager()
    private let user = User()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentDate: Int = Date().getCurrentDate()
    
    var header: String {
        readToken()
        return tokenType + " " + accessToken
    }
    
    private var model: TokenData {
        .init(refreshToken: refreshToken)
    }
    
    //MARK: Save Token
    func saveToken() {
        let data = Data(accessToken.utf8)
        do {
            try keychain.save(data: data,
                              service: "unlockToken",
                              account: user.email)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception setting Access Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred setting the Access Token: \(error)")
        }
    }
    
    //MARK: Read Token
    private func readToken() {
        do {
            let data = try keychain.read(service: "unlockToken",
                                         account: user.email)
            accessToken = String(decoding: data, as: UTF8.self).fromBase64() ?? ""
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception reading Access Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred reading the Access Token: \(error)")
        }
    }
    
    //MARK: Update Token
    private func updateToken() {
        let data = Data(accessToken.utf8)
        do {
            try keychain.update(data: data,
                                service: "unlockToken",
                                account: user.email)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception updating Access Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred updating the Access Token: \(error)")
        }
    }
    
    //MARK: Save Refresh Token
    func saveRefreshToken() {
        let data = Data(accessToken.utf8)
        do {
            try keychain.save(data: data,
                              service: "unlockRefreshToken",
                              account: user.email)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception setting Refresh Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred setting the Refresh Token: \(error)")
        }
    }
    
    //MARK: Read Refresh Token
    private func readRefreshToken() {
        do {
            let data = try keychain.read(service: "unlockRefreshToken",
                                         account: user.email)
            
            let token = String(decoding: data, as: UTF8.self)
            refreshToken = token.fromBase64() ?? ""
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception reading Refresh Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred reading the Refresh Token: \(error)")
        }
    }
    
    //MARK: Update Refresh Token
    private func updateRefreshToken() {
        let data = Data(accessToken.utf8)
        do {
            try keychain.update(data: data,
                                service: "unlockRefreshToken",
                                account: user.email)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception updating Refresh Token: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred updating the Refresh Token: \(error)")
        }
    }
    
    //MARK: Get New Token
    private func getNewToken() {
        authService.refreshToken(model: model)
            .sink(receiveCompletion: { error in
                switch error {
                case .finished:
                    return
                case .failure(let error):
                    print(error.description)
                }
            }, receiveValue: { [weak self] tokens in
                if tokens.data.message == nil {
                    guard let self = self else { return }
                    self.accessToken = tokens.data.accessToken?.toBase64() ?? "no data"
                    self.refreshToken = tokens.data.refreshToken?.toBase64() ?? "no data"
                    self.expireDate = tokens.data.expiresIn ?? 0
                    self.updateToken()
                    self.updateRefreshToken()
                }
            })
            .store(in: &cancellables)
    }
}
