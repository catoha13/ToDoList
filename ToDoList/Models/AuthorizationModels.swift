import Foundation

struct SignInRequestModel: Codable {
    var data: [Model]
}
struct Model: Codable {
    var email: String = ""
    var password: String = ""
    var username: String = ""
}

struct SignInResponseModel: Codable {
    var data: SignInResponse
}

struct SignInResponse: Codable {
    var user_id: String
    var access_token: String
    var token_type: String
    var refresh_token: String
    var expires_in: Int
}

struct SignUpResponseModel: Codable {
    var data: SignUpResponse
}

struct SignUpResponse: Codable {
    var id: String
    var email: String
    var username: String
    var avatar_url: String?
    var user_session: UserSession
    var message: String
    var code: Int
}

struct UserSession: Codable {
    var access_token: String
    var refresh_token: String
    var expires_in: Int
}
