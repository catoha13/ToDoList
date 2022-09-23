import Foundation

struct ProfileResponseModel: Codable {
    var data: ProfileResponseData
}

struct ProfileResponseData: Codable {
    var id: String?
    var email: String?
    var username: String?
    var avatarUrl: String?
    var createdAt: String?
    var message: String?
    var code: Int?
}

struct FetchUserStatisticsModel: Codable {
    var data: FetchUserStatisticsData
}

struct FetchUserStatisticsData: Codable {
    var createdTasks: Int?
    var completedTasks: Int?
    var events: String?
    var quickNotes: String?
    var todo: String?
    var message: String?
    var code: Int?
}
