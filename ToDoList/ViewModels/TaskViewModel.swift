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
    @Published var users: [Member] = []
    @Published var usersUrls: [String] = []
    @Published var userUrl = ""
    @Published var usersAvatars: [UIImage] = []
    @Published var usersAndAvatars: [(Member, UIImage, id: UUID)] = []
    
    //MARK: Update Task
    @Published var showTaskCompletionView = false
    
    //MARK: Delete Task
    @Published var taskId = ""
    @Published var tasksResponseArray: [FetchComments] = []
    
    //MARK: CreateTaskView
    @Published var membersUrl = ""
    @Published var membersUrls: [String] = []
    @Published var membersAvatars: [UIImage] = []
    @Published var mergedMebmersAndAvatars: [(Member, UIImage, id: UUID)] = []
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
    @Published var searchUsersResponseArray: [Member] = []
    @Published var searchProjectsResoponseArray: [ProjectResponceData] = []
    @Published var selectedUser = ""
    @Published var selectedUserAvatar: UIImage?
    @Published var selectedProjectName = ""
    @Published var selectedProjectId = ""
    private var id = [UUID]()
    
    //MARK: Add members
    @Published var showAddMemberView = false
    @Published var members: [Member]? = []
    @Published var addedMembersAvatars: [UIImage] = []
    
    //MARK: Network Alert
    @Published var alertMessage = ""
    @Published var showNetworkAlert = false
    
    private let user = User()
    private var taskService = TaskNetworkService()
    var cancellables = Set<AnyCancellable>()
    
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
    let createTask = PassthroughSubject<Void, Never>()
    let updateTask = PassthroughSubject<Void, Never>()
    let deleteTask = PassthroughSubject<Void, Never>()
    let fetchUserTasks = PassthroughSubject<Void, Never>()
    let searchMembersAndProjects = PassthroughSubject<Void, Never>()
    let loadMembers = PassthroughSubject<Void, Never>()
    let loadAddMembers = PassthroughSubject<Void, Never>()
    let createComment = PassthroughSubject<Void, Never>()
    let fetchComments = PassthroughSubject<Void, Never>()
    let deleteComment = PassthroughSubject<Void, Never>()
    
    //MARK: Initialization
    init() {
        addSubscriptions()
        fetchUserTasks.send()
    }
    
    //MARK: Funcs
    private func addSubscriptions() {
        createTask
            .sink { [weak self] _ in
                self?.createTaskRequest()
            }
            .store(in: &cancellables)
        
        updateTask
            .sink { [weak self] _ in
                self?.updateTaskRequest()
            }
            .store(in: &cancellables)
        
        deleteTask
            .sink { [weak self] _ in
                self?.deleteTaskRequest()
            }
            .store(in: &cancellables)
        
        fetchUserTasks
            .sink { [weak self] _ in
                self?.fetchUserTasksRequest()
            }
            .store(in: &cancellables)
        
        searchMembersAndProjects
            .sink { [weak self] _ in
                self?.loadMembersAndProjectsSearchRequest()
            }
            .store(in: &cancellables)
        
        loadMembers
            .sink { [weak self] _ in
                self?.loadMembersAvatarsRequest()
            }
            .store(in: &cancellables)
        
        loadAddMembers
            .sink { [weak self] _ in
                self?.loadAddMembersRequest()
            }
            .store(in: &cancellables)
        
        createComment
            .sink { [weak self] _ in
                self?.createCommentRequest()
            }
            .store(in: &cancellables)
        
        fetchComments
            .sink { [weak self] _ in
                self?.fetchCommentsRequest()
            }
            .store(in: &cancellables)
    }
    
    private func createTaskRequest() {
        taskService.createTask(model: createTaskModel)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self ]item in
                self?.objectWillChange.send()
                self?.fetchUserTasksRequest()
            })
            .store(in: &cancellables)
    }
    
    private func updateTaskRequest() {
        taskService.updateTask(model: updateTaskModel, taskId: taskId)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.objectWillChange.send()
                self?.fetchUserTasksRequest()
            })
            .store(in: &cancellables)
    }
    
    private func deleteTaskRequest() {
        taskService.deleteTask(taskId: taskId)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchUserTasksRequest()
            })
            .store(in: &cancellables)
    }
    
    private func fetchUserTasksRequest() {
        taskService.fetchUserTasks()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.objectWillChange.send()
                self?.fetchTasksResponse = item.data
            })
            .store(in: &cancellables)
    }
        
    private func loadMembersAndProjectsSearchRequest() {
        taskService.taskMembersSearch().zip(taskService.projectsSearch())
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] users, project in
                self?.searchUsersResponseArray = users.data.sorted(by: {$0.username < $1.username})
                for member in users.data.sorted(by: {$0.username < $1.username}) {
                    self?.membersUrls.append(member.avatarUrl)
                }
                self?.searchProjectsResoponseArray = project.data
                self?.loadMembersAvatarsRequest()
            })
            .store(in: &cancellables)
    }
    
    private func loadMembersAvatarsRequest() {
        for count in 0..<membersUrls.count {
            membersUrl = membersUrls[count]
            taskService.downloadMembersAvatars(url: membersUrl)
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
    
    private func loadAddMembersRequest() {
        taskService.taskMembersSearch()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.users = item.data.sorted(by: { $0.username < $1.username})
                for user in item.data.sorted(by: { $0.username < $1.username}) {
                    self?.usersUrls.append(user.avatarUrl)
                }
                self?.loadAddMemberAvatars()
            })
            .store(in: &cancellables)
    }
    private func loadAddMemberAvatars() {
        for count in 0..<usersUrls.count {
            userUrl = usersUrls[count]
            taskService.downloadMembersAvatars(url: userUrl)
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
    
    private func createCommentRequest() {
        taskService.createTaskComment(model: createCommentModel)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchCommentsRequest()
            })
            .store(in: &cancellables)
    }
    
    private func fetchCommentsRequest() {
        taskService.fetchTaskComments(taskId: taskId)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.commentsResponseArray = item.data
            })
            .store(in: &cancellables)
    }
    
    private func deleteCommentRequest() {
        taskService.deleteTaskComment(commentId: commentId)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchCommentsRequest()
            })
            .store(in: &cancellables)
    }
    
    func formatDueDate(date: Date, time: Date) -> String {
        let dayFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dayFormatter.dateFormat = "YYYY-MM-dd"
        timeFormatter.dateFormat = "hh:mm:ss.ssssss"
        return "\(dayFormatter.string(from: date))T\(timeFormatter.string(from: time))"
        
    }
}
