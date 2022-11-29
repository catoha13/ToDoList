import Foundation

struct ProjectModel: Codable {
    var title: String
    var color: String
    var ownerId: String
}

struct ProjectResponceModel: Codable {
    var data: ProjectResponceData
}

struct ProjectResponceData: Codable, Hashable {
    var id: String?
    var title: String?
    var color: String?
    var ownerId: String?
    var createdAt: String?
    var message: String?
    var code: Int?
}

struct FetchProjectsResponceModel: Codable {
    var data: [ProjectResponceData]
}


