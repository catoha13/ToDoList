import Foundation

struct ChecklistResponseModel: Codable {
    var data: ChecklistData
}

struct ChecklistData: Codable {
    var id: String
    var title: String
    var color: String
    var ownerId: String
    var items: [ChecklistItemsModel]
    var createdAt: String
}

struct ChecklistItemsModel: Codable {
    var id: String
    var content: String
    var checklistId: String
    var isCompleted: Bool
    var createdAt: String
}

struct ChecklistRequestModel: Codable {
    var title: String
    var color: String
    var ownerId: String
    var items: [ChecklistItemsRequest?]
}

struct ChecklistItemsRequest: Codable {
    var content: String
    var isCompleted: Bool
}

struct FetchAllChecklistsModel: Codable {
    var data: [ChecklistData]
}

