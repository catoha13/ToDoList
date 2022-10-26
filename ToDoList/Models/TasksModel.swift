import Foundation

struct TaskResponseModel: Codable {
    var data: TaskResponseData
}
struct TaskResponseData: Codable, Hashable {
    var id: String
    var title: String
    var dueDate: String
    var description: String
    var assignedTo: String
    var isCompleted: Bool
    var projectId: String
    var ownerId: String
    var members: [Members]?
    var attachments: [Attachments]?
    var createdAt: String
}

struct Members: Codable, Hashable {
    var id: String
    var email: String
    var username: String
    var avatarUrl: String
    var createdAt: String
}

struct Attachments: Codable, Hashable {
    var id: String
    var url: String
    var type: String
    var taskId: String
    var createdAt: String
}

struct CreateTaskModel: Codable {
    var title: String
    var dueDate: String
    var description: String
    var assigned_to: String
    var isCompleted: Bool
    var projectId: String
    var ownerId: String
    var members: [String]?
    var attachments: [Attachments]?
}

struct FetchTasks: Codable {
    var data: [TaskResponseData]
}

struct SearchUsers: Codable {
    var data: [Members]
}

struct SearchProjects: Codable {
    var data: [ProjectResponceData]
}

struct DeleteModel: Codable {
    var data: DeleteData
}
struct DeleteData: Codable {
    var id: String
}
