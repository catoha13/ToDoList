import Foundation

//MARK: Route
enum Route: String {
    case signIn = "/sign-in"
    case signUp = "/sign-up"
}

//MARK: Environment
enum Endpoint: String {
    case authorization = "https://todolist.dev2.cogniteq.com/api/v1"
}

//MARK: Method
enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    
}
