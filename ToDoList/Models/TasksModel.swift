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
    var members: [Member]?
    var attachments: [Attachments]?
    var createdAt: String
}

struct Member: Codable, Hashable {
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
    var data: [Member]
}

struct SearchProjects: Codable {
    var data: [ProjectResponceData]
}

struct DeleteTaskModel: Codable {
    var data: DeleteTaskData
}
struct DeleteTaskData: Codable {
    var id: String
}

struct CreateCommentModel: Codable {
    var content: String
    var taskId: String
    var ownerId: String
}

struct FetchComments: Codable, Hashable {
    var data: [FetchCommentsData]
}

struct FetchCommentsData: Codable, Hashable {
    var id: String
    var content: String
    var taskId: String
    var ownerId: String
    var commentator: Member?
    var attachments: [Attachments]?
    var createdAt: String
}

struct DeleteCommentModel: Codable {
    var data: DeleteCommentData
}

struct DeleteCommentData: Codable {
    var id: String
}
