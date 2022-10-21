import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    //MARK: Create task
    @Published var assigneeName = ""
    @Published var assigneeId = ""
    @Published var projectName = ""
    @Published var title = ""
    @Published var description = ""
    @Published var getDate = "Anytime"
    @Published var members: [Members]? = []
    @Published var showDatePicker = false
    @Published var selectedDate: Date?
    
    //MARK: Search
    @Published var searchUsersResponseArray: [Members] = []
    @Published var searchProjectsResoponseArray: [ProjectResponceData] = []
    @Published var selectedUser = ""
    @Published var selectedUserAvatar: UIImage?
    @Published var selectedProjectName = ""
    @Published var selectedProjectId = ""
    
    //MARK: TaskView
    @Published var selectedIndex = 0
    @Published var membersUrl = ""
    @Published var membersUrls: [String] = []
    @Published var membersAvatars: [UIImage] = []
    @Published var mergedUsersAndAvatars: [(Members, UIImage, id: UUID)] = []
    
    //MARK: Add members
    @Published var showAddMemberView = false
    @Published var addedMembersAvatars: [UIImage] = []
    
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
                        projectId: "", // project id
                        ownerId: ownerId,
                        members: members,
                        attachments: nil)
    }
    
    //MARK: Publishers
    private var searchMembers: AnyPublisher<SearchUsers, NetworkError> {
        taskService.taskMembersSearch()
    }
    private var downloadUsersAvatars: AnyPublisher<UIImage, NetworkError> {
        taskService.downloadMembersAvatars(url: membersUrl)
    }
    
    private var searchProjects: AnyPublisher<SearchProjects, NetworkError> {
        taskService.projectsSearch()
    }
    
    //MARK: Initialization
    init() {
        loadMembers()
        loadProjects()
    }
    
    //MARK: Funcs
    private func loadMembers() {
        searchMembers
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.searchUsersResponseArray = item.data
                for member in item.data {
                    self?.membersUrls.append(member.avatarUrl)
                }
                self?.loadAvatars()
            })
            .store(in: &cancellables)
    }
    
    private func loadAvatars() {
        for count in 0..<membersUrls.count {
            membersUrl = membersUrls[count]
            downloadUsersAvatars
                .sink { _ in
                } receiveValue: { [weak self] item in
                    self?.membersAvatars.append(item)
                    var id = [UUID]()
                    for _ in 0...(self?.membersAvatars.count ?? 0) {
                        id.append(UUID())
                    }
                    self?.mergedUsersAndAvatars = Array(zip(self?.searchUsersResponseArray ?? [], self?.membersAvatars ?? [], id))
                }
                .store(in: &cancellables)
        }
    }
    
    private func loadProjects() {
        searchProjects
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.searchProjectsResoponseArray = item.data
            })
            .store(in: &cancellables)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
