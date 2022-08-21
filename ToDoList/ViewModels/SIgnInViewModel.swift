import Foundation
import SwiftUI

final class SignInViewModel: ObservableObject {
    
    private  var signInViewService = SignInService()
    
    @Published var username = ""
    @Published var password = ""
    
    func signIn() {
        signInViewService.post(body: Model(email: username, password: password, username: username),
                               url: Endpoint.authorization.rawValue + Route.signIn.rawValue) { (_ response: Result<SignInResponseModel, Error>) in
            switch response {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
