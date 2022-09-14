import Foundation

struct NotesModel: Codable {
    var description: String
    var color: String
    var ownerId: String
}

struct NotesResponseModel: Codable {
    var data: NotesResponseData
}

struct NotesResponseData: Codable {
    var id: String?
    var description: String?
    var color: String?
    var ownerId: String?
    var isCompleted: Bool?
    var createdAt: String?
    var message: String?
    var code: Int?
}

struct FetchAllNotesModel: Codable {
    var data: FetchProjectsData
}
struct FetchAllNotesData: Codable {
    var ownerId: String
}
