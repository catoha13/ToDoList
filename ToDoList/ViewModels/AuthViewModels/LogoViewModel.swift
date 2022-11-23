import SwiftUI

final class LogoViewModel: ObservableObject {
    @AppStorage("firstAccess") var firstAccess: Bool = true
    
    @Published var isSignedIn = false
    
    @Published var selectedTab = 0
    @Published var showOnboarding = false
    @Published var showSignUp = false
    @Published var showMainScreen = false
    
    private let user = User()
    private let hoursToExpire = 48
    private let currentDate = Date()
    private let signedInDate = UserDefaults.standard.value(forKey: "signedInDate") as? Date
    
    init() {
        checkUser()
    }
    
    private func checkUser() {
        user.readPassword()
        if !user.password.isEmpty {
            checkExpireDate()
            UserDefaults.standard.set(Date(), forKey: "signedInDate")
        }
    }
    
    private func checkExpireDate() {
        let diffComponents = Calendar.current.dateComponents([.hour], from: signedInDate ?? Date(), to: currentDate)
        let hours = diffComponents.hour
        
        guard let hours = hours else { return }
        if hours <= hoursToExpire {
            isSignedIn = true
        }
    }
}
