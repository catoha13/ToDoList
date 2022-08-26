import Foundation

struct RequestModel: Codable {
    var data: [Model]
}
struct Model: Codable {
    var email: String = ""
    var password: String = ""
    var username: String = ""
}

struct SignInResponceModel: Codable {
    var data: SignInResponce
}

struct SignInResponce: Codable {
    var user_id: String?
    var access_token: String?
    var token_type: String?
    var refresh_token: String?
    var expires_in: Int?
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
    var avatar_url: String?
    var user_session: UserSession?
    var message: String?
    var code: Int?
}

struct UserSession: Codable {
    var access_token: String
    var refresh_token: String
    var expires_in: Int
}
