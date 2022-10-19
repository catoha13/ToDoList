import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    //MARK: Create task
    @Published var assignee = ""
    @Published var projectName = "Personal"
    @Published var title = ""
    @Published var description = ""
    @Published var getDate = "Anytime"
    @Published var addTaskPressed = false
    @Published var showSideView = false
    @Published var searchedUser = ""
    @Published var selectedUsers: [Members] = []
    
    //MARK: TaskView
    @Published var selectedIndex = 0
    @Published var membersUrls: [String] = []
    @Published var membersUrl = ""
    @Published var membersAvatars: [UIImage] = []
    
    //MARK: var
    @Published var searchUsersArray: [Members] = []
    
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
                        assigned_to: "some project", // ????
                        isCompleted: false,
                        projectId: "", // project id
                        ownerId: ownerId,
                        members: nil, // model??
                        attachments: nil) // model??
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
        search()
    }
    
    //MARK: Funcs
    private func search() {
        searchMembers
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] item in
                self?.searchUsersArray = item.data
                for member in item.data {
                    self?.membersUrls.append(member.avatarUrl)
                }
            })
            .store(in: &cancellables)
    }
    private func loadAvatars() {
        for _ in 0...membersUrls.count {
            downloadUsersAvatars
                .sink { item in
                    switch item {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error)
                    }
                } receiveValue: { [weak self] item in
                    self?.membersAvatars.append(item)
                }
                .store(in: &cancellables)
        }
    }
}
