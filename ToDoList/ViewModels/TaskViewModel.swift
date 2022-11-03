import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    //MARK: MyTaskView
    @Published var selectedIndex = 0
    @Published var selectedDate: Date?
    @Published var fetchTasksResponse: [TaskResponseData] = []
    @Published var filterCompletedTasks: Bool? = false
    @Published var filterIndex = 0
    @Published var showFilter = false
    @Published var users: [Members] = []
    @Published var usersUrls: [String] = []
    @Published var userUrl = ""
    @Published var usersAvatars: [UIImage] = []
    @Published var usersAndAvatars: [(Members, UIImage, id: UUID)] = []
    
    //MARK: Update Task
    @Published var showTaskCompletionView = false
    
    //MARK: Delete Task
    @Published var taskId = ""
    @Published var tasksResponseArray: [FetchComments] = []
    
    //MARK: CreateTaskView
    @Published var membersUrl = ""
    @Published var membersUrls: [String] = []
    @Published var membersAvatars: [UIImage] = []
    @Published var mergedMebmersAndAvatars: [(Members, UIImage, id: UUID)] = []
    @Published var selectedTime: Date?
    
    //MARK: Create task model
    @Published var assigneeName = ""
    @Published var assigneeId = ""
    @Published var isCompleted = false
    @Published var projectName = ""
    @Published var title = ""
    @Published var description = ""
    @Published var getDate = "Anytime"
    @Published var membersId: [String]? = []
    @Published var showDatePicker = false
    @Published var dueDate: Date?
    
    //MARK: Create comment model
    @Published var commentText = ""
    @Published var commentsResponseArray: [FetchCommentsData] = []
    
    //MARK: Delete comment
    @Published var commentId = ""
    
    //MARK: Search
    @Published var searchUsersResponseArray: [Members] = []
    @Published var searchProjectsResoponseArray: [ProjectResponceData] = []
    @Published var selectedUser = ""
    @Published var selectedUserAvatar: UIImage?
    @Published var selectedProjectName = ""
    @Published var selectedProjectId = ""
    private var id = [UUID]()
    
    //MARK: Add members
    @Published var showAddMemberView = false
    @Published var members: [Members]? = []
    @Published var addedMembersAvatars: [UIImage] = []
    
    private var token = Token()
    private let user = User()
    private var taskService = TaskNetworkService()
     var cancellables = Set<AnyCancellable>()
    
    private var header: String {
        return (token.tokenType ?? "") + " " + (token.savedToken ?? "")
    }
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    //MARK: Models
    private var createTaskModel: CreateTaskModel {
        CreateTaskModel(title: title,
                        dueDate: getDate,
                        description: description,
                        assigned_to: assigneeId,
                        isCompleted: false,
                        projectId: selectedProjectId,
                        ownerId: ownerId,
                        members: membersId,
                        attachments: nil)
    }
    
    private var updateTaskModel: CreateTaskModel {
        CreateTaskModel(title: title,
                        dueDate: getDate,
                        description: description,
                        assigned_to: assigneeId,
                        isCompleted: isCompleted,
                        projectId: selectedProjectId,
                        ownerId: ownerId,
                        members: membersId,
                        attachments: nil)
    }
    
    private var createCommentModel: CreateCommentModel {
        CreateCommentModel(content: commentText,
                      taskId: taskId,
                      ownerId: ownerId)
    }
    
    //MARK: Publishers
    private var createTaskRequest: AnyPublisher<TaskResponseModel, NetworkError> {
        taskService.createTask(model: createTaskModel)
    }
    
    private var updateTaskRequest: AnyPublisher<TaskResponseModel, NetworkError> {
        taskService.updateTask(model: updateTaskModel, taskId: taskId)
    }
    
    private var deleteTaskRequest: AnyPublisher<DeleteTaskModel, NetworkError> {
        taskService.deleteTask(taskId: taskId)
    }
    
    private var fetchUserTasksRequest: AnyPublisher<FetchTasks, NetworkError> {
        taskService.fetchUserTasks()
    }
    
    private var searchMembers: AnyPublisher<SearchUsers, NetworkError> {
        taskService.taskMembersSearch()
    }
    
    private var downloadMembersAvatars: AnyPublisher<UIImage?, NetworkError> {
        taskService.downloadMembersAvatars(url: membersUrl)
    }

    private var downloadUsersAvatars: AnyPublisher<UIImage?, NetworkError> {
        taskService.downloadMembersAvatars(url: userUrl)
    }

    private var searchProjects: AnyPublisher<SearchProjects, NetworkError> {
        taskService.projectsSearch()
    }
    
    private var createCommentRequest: AnyPublisher<FetchComments, NetworkError> {
        taskService.createTaskComment(model: createCommentModel)
    }
    
    private var fetchCommentsRequest: AnyPublisher<FetchComments, NetworkError> {
        taskService.fetchTaskComments(taskId: taskId)
    }
    
    private var deleteCommentRequest: AnyPublisher<DeleteCommentModel, NetworkError> {
        taskService.deleteTaskComment(commentId: commentId)
    }
    
    //MARK: Initialization
    init() {
        fetchUserTasks()
    }
    
    //MARK: Funcs
    func createTask() {
        createTaskRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self ]item in
                self?.fetchUserTasks()
            })
            .store(in: &cancellables)
    }
    
    func updateTask() {
        updateTaskRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchUserTasks()
            })
            .store(in: &cancellables)
    }
    
    func deleteTask() {
        deleteTaskRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                print(item)
                self?.fetchUserTasks()
            })
            .store(in: &cancellables)
    }
    
    func fetchUserTasks() {
        fetchUserTasksRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchTasksResponse = item.data
            })
            .store(in: &cancellables)
    }
    
    func loadSearch() {
        searchMembers.zip(searchProjects)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] users, project in
                self?.searchUsersResponseArray = users.data.sorted(by: {$0.username < $1.username})
                for member in users.data.sorted(by: {$0.username < $1.username}) {
                    self?.membersUrls.append(member.avatarUrl)
                }
                self?.searchProjectsResoponseArray = project.data
                self?.loadAvatars()
            })
            .store(in: &cancellables)
    }
    
    func loadAvatars() {
        for count in 0..<membersUrls.count {
            membersUrl = membersUrls[count]
            downloadMembersAvatars
                .sink { _ in
                } receiveValue: { [weak self] item in
                    self?.membersAvatars.append(item ?? UIImage(named: "background")!)
                    for _ in 0...(self?.membersAvatars.count ?? 0) {
                        self?.id.append(UUID())
                    }
                    self?.mergedMebmersAndAvatars = Array(zip(self?.searchUsersResponseArray ?? [], self?.membersAvatars ?? [], self?.id ?? []))
                }
                .store(in: &cancellables)
        }
    }
    
    func loadUsers() {
        searchMembers
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.users = item.data.sorted(by: { $0.username < $1.username})
                for user in item.data.sorted(by: { $0.username < $1.username}) {
                    self?.usersUrls.append(user.avatarUrl)
                }
                self?.loadUserAvatars()
            })
            .store(in: &cancellables)
    }
    private func loadUserAvatars() {
        for count in 0..<usersUrls.count {
            userUrl = usersUrls[count]
            downloadUsersAvatars
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] item in
                    self?.usersAvatars.append(item ?? UIImage(named: "background")!)
                    for _ in 0...(self?.usersAvatars.count ?? 0) {
                        self?.id.append(UUID())
                    }
                    self?.usersAndAvatars = Array(zip(self?.users ?? [], self?.usersAvatars ?? [], self?.id ?? []))
                })
                .store(in: &cancellables)
        }
    }
    
    func createComment() {
        createCommentRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchComments()
            })
            .store(in: &cancellables)
    }
    
    func fetchComments() {
        fetchCommentsRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.commentsResponseArray = item.data
            })
            .store(in: &cancellables)
    }
    
    func deleteComment() {
        deleteCommentRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchComments()
            })
            .store(in: &cancellables)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func formatDueDate(date: Date, time: Date) -> String {
        let dayFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dayFormatter.dateFormat = "YYYY-MM-dd"
        timeFormatter.dateFormat = "hh:mm:ss.ssssss"
        return "\(dayFormatter.string(from: date))T\(timeFormatter.string(from: time))"
        
    }
}
