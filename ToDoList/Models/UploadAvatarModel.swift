import Foundation

struct UploadAvatar: Codable {
    var data: UploadAvatarResponce
}

struct UploadAvatarResponce: Codable {
    var id: String?
    var email: String?
    var username: String?
    var avatarUrl: String?
    var createdAt: String?
    var message: String?
    var code: Int?
}
