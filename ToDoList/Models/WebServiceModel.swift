import Foundation

//MARK: Path
enum Path: String {
    case signIn = "/sign-in"
    case signUp = "/sign-up"
    case signOut = "/sign-out"
    case refreshToken = "/refresh-token"
    case projects = "/projects"
    case fetchProjects = "/user-projects/"
    case note = "/notes"
    case fetchNotes = "/user-notes"
    case fetchUser = "/users/"
    case fetchUserStatistics = "/users-statistics/"
    case userAvatar = "/users-avatar"
    case checklists = "/checklists"
    case checklistsItems = "/checklists-items"
    case usersChecklists = "/user-checklists/"
    case tasks = "/tasks"
    case projectTasks = "/project-tasks/"
    case userTasks = "/user-tasks/"
    case assignedTasks = "/assigned-tasks/"
    case participateInTasks = "/participate-in-tasks/"
    case tasksAttachments = "/tasks-attachments"
    case comments = "/comments"
    case taskComments = "/tasks-comments/"
    case membersSearch = "/task-members-search?query=kas"
    case projectSearch = "/projects-search?query=roj"
    case commentsAttachments = "/comments-attachments"
}

//MARK: Endpoint
enum BaseUrl: String {
    case baseUrl = "https://todolist.dev2.cogniteq.com/api/v1"
}

//MARK: Method
enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}
