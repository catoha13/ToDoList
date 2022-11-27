import SwiftUI

final class LogoViewModel: ObservableObject {
    @AppStorage("firstAccess") var firstAccess: Bool = true
    
    @Published var isSignedIn = false
    
    @Published var selectedTab = 0
    @Published var showOnboarding = false
    @Published var showSignUp = false
    @Published var showMainScreen = false
    
    private let user = User()
    private let token = Token()
    private let hoursToExpire = 48
    private let currentDate = Date()
    
    init() {
        checkUser()
    }
    
    private func checkUser() {
        user.readPassword()
        if !user.password.isEmpty {
            checkExpireDate()
        }
    }
    
    private func checkExpireDate() {
        let diffComponents = Calendar.current.dateComponents([.hour], from: convertExpireDate(), to: currentDate)
        let hours = diffComponents.hour
        
        guard let hours = hours else { return }
        if hours <= hoursToExpire {
            isSignedIn = true
            
        } else {
            isSignedIn = false
        }
    }
    
    private func convertExpireDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(token.expireDate?.trimExpireDate() ?? 0 ))
     
    }
}
