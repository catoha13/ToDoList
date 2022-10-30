import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
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
    
    //MARK: CreateTaskView
    @Published var membersUrl = ""
    @Published var membersUrls: [String] = []
    @Published var membersAvatars: [UIImage] = []
    @Published var mergedUsersAndAvatars: [(Members, UIImage, id: UUID)] = []
    @Published var selectedTime: Date?
    
    //MARK: MyTaskView
    @Published var selectedIndex = 0
    @Published var selectedDate: Date?
    @Published var fetchTasksResponse: [TaskResponseData] = []
    
    //MARK: Update Task
    @Published var showTaskCompletionView = false
    
    //MARK: Delete Task
    @Published var taskId = ""
    
    private var token = Token()
    private let user = User()
    private var taskService = TaskNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    //MARK: Publishers
    private var createTaskRequest: AnyPublisher<TaskResponseModel, NetworkError> {
        taskService.createTask(model: createTaskModel)
    }
    
    private var updateTaskRequest: AnyPublisher<TaskResponseModel, NetworkError> {
        taskService.updateTask(model: updateTaskModel, taskId: taskId)
    }
    
    private var deleteTaskRequest: AnyPublisher<DeleteModel, NetworkError> {
        taskService.deleteTask(taskId: taskId)
    }
    
    private var fetchUserTasksRequest: AnyPublisher<FetchTasks, NetworkError> {
        taskService.fetchUserTasks()
    }
    
    private var searchMembers: AnyPublisher<SearchUsers, NetworkError> {
        taskService.taskMembersSearch()
    }
    
    private var downloadUsersAvatars: AnyPublisher<UIImage?, NetworkError> {
        taskService.downloadMembersAvatars(url: membersUrl)
    }
    
    private var searchProjects: AnyPublisher<SearchProjects, NetworkError> {
        taskService.projectsSearch()
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
            downloadUsersAvatars
                .sink { _ in
                } receiveValue: { [weak self] item in
                    self?.membersAvatars.append(item ?? UIImage(named: "background")!)
                    for _ in 0...(self?.membersAvatars.count ?? 0) {
                        self?.id.append(UUID())
                    }
                    self?.mergedUsersAndAvatars = Array(zip(self?.searchUsersResponseArray ?? [], self?.membersAvatars ?? [], self?.id ?? []))
                }
                .store(in: &cancellables)
        }
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
