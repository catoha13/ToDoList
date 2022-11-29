import Foundation
import SwiftUI

final class User {
    @AppStorage("id") var id: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("avatar") var avatar: String = ""
    @Published var password = ""
    
    private let keychain = KeychainManager()

    func savePassword() {
        let data = Data(password.utf8)
        do {
            try keychain.save(data: data,
                              service: "unlockPassword",
                              account: email)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception setting password: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred setting the password: \(error)")
        }
    }
    
    func readPassword() {
        do {
            let data = try keychain.read(service: "unlockPassword",
                                         account: email)
            password = String(decoding: data, as: UTF8.self)
            
        } catch let error as KeychainManager.KeychainError {
            print("Exception loading password: \(error.localizedDescription).")
        }
        catch {
            print("An error occurred reading the password: \(error)")
        }
    }
}



