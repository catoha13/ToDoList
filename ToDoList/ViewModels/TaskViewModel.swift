import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    //MARK: Create task
    @Published var assigneeName = ""
    @Published var assigneeId = ""
    @Published var projectName = "Personal"
    @Published var title = ""
    @Published var description = ""
    @Published var getDate = "Anytime"
    @Published var selectedUser = ""
    @Published var selectedUserAvatar: UIImage?
    @Published var members: [Members]? = []
    
    //MARK: TaskView
    @Published var selectedIndex = 0
    @Published var membersUrl = ""
    @Published var membersUrls: [String] = []
    @Published var membersAvatars: [UIImage] = []
    @Published var mergedUsersAndAvatars: [(Members, UIImage, id: UUID)] = []
    
    //MARK: Search
    @Published var searchUsersArray: [Members] = []
    
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
    
    //MARK: Initialization
    init() {
        loadMembers()
    }
    
    //MARK: Funcs
    private func loadMembers() {
        searchMembers
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.searchUsersArray = item.data
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
                    self?.mergedUsersAndAvatars = Array(zip(self?.searchUsersArray ?? [], self?.membersAvatars ?? [], id))
                }
                .store(in: &cancellables)
        }
    }
}