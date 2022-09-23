import Foundation

//MARK: Path
enum Path: String {
    case signIn = "/sign-in"
    case signUp = "/sign-up"
    case refreshToken = "/refresh-token"
    case projects = "/projects"
    case fetchProjects = "/user-projects/"
    case fetchUser = "/users/"
    case fetchUserStatistics = "/users-statistics/"
    case userAvatar = "/users-avatar"
}

//MARK: Endpoint
enum BaseUrl: String {
    case authorization = "https://todolist.dev2.cogniteq.com/api/v1"
}

//MARK: Method
enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}
