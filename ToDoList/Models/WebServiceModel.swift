import Foundation

//MARK: Path
enum Path: String {
    case signIn = "/sign-in"
    case signUp = "/sign-up"
}

//MARK: Endpoint
enum Endpoint: String {
    case authorization = "https://todolist.dev2.cogniteq.com/api/v1"
}

//MARK: Method
enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}
