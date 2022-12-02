import Foundation

struct CreateNoteModel: Codable {
    var description: String
    var color: String
    var ownerId: String
}

struct NotesModel: Codable {
    var description: String
    var color: String
    var ownerId: String
    var isCompleted: Bool
}

struct NotesResponseModel: Codable {
    var data: NotesResponseData
}

struct NotesResponseData: Codable, Hashable {
    var id: String?
    var description: String?
    var color: String?
    var ownerId: String?
    var isCompleted: Bool?
    var createdAt: String?
    var message: String?
    var code: Int?
}

struct FetchAllNotesResponseModel: Codable, Hashable {
    var data: [NotesResponseData]
}
