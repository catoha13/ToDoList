import Foundation

struct ChecklistResponseModel: Codable {
    var data: ChecklistData
}

struct ChecklistData: Codable, Hashable {
    var id: String
    var title: String
    var color: String
    var ownerId: String
    var items: [ChecklistItemsModel]
    var createdAt: String
    var message: String?
    var code: Int?
}

struct ChecklistItemsModel: Codable, Hashable {
    var id: String?
    var content: String
    var checklistId: String?
    var isCompleted: Bool
    var createdAt: String?
}

struct ChecklistUpdateRequestModel: Codable {
    var title: String
    var color: String
    var ownerId: String
    var items: [ChecklistItemsModel?]
}

struct DeleteChecklistModel: Codable {
    var data: DeleteChecklistData
}
struct DeleteChecklistData: Codable {
    var id: String
}

struct FetchAllChecklistsResponseModel: Codable {
    var data: [ChecklistData]
}

