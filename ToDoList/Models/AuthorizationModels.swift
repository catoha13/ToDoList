import Foundation

struct RequestBodyModel: Codable {
    var email: String = ""
    var password: String = ""
    var username: String = ""
}

struct SignInResponceModel: Codable {
    var data: SignInResponce
}

struct SignInResponce: Codable {
    var userId: String?
    var accessToken: String?
    var tokenType: String?
    var refreshToken: String?
    var expiresIn: Int?
    var message: String?
    var code: Int?
}

struct SignUpResponceModel: Codable {
    var data: SignUpResponce
}

struct SignUpResponce: Codable {
    var id: String?
    var email: String?
    var username: String?
    var avatarUrl: String?
    var userSession: UserSession?
    var message: String?
    var code: Int?
}

struct UserSession: Codable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    var expiresIn: Int
}

struct RefreshTokenModel: Codable {
    var data: TokenData
}
struct TokenData: Codable {
    var accessToken: String?
    var tokenType: String?
    var refreshToken: String?
    var expiresIn: Int?
    var message: String?
    var code: Int?
}
