import SwiftUI
import Combine

final class MenuViewModel: ObservableObject {
    
    var isPresented = CurrentValueSubject<Bool, Never>(false)
    var isEditing = CurrentValueSubject<Bool, Never>(false)
    var showAlert = CurrentValueSubject<Bool, Never>(false)
    
    var projectName = CurrentValueSubject<String, Never>("")
    var chosenColor = CurrentValueSubject< String, Never>("")
    var projectsArray = CurrentValueSubject<[FetchProjectsData], Never>([])
    var selectedProjectId = CurrentValueSubject<String, Never>("")
    
    @Published var flexibleLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var token = Token()
    private let user = User()
    private var projectService = ProjectNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var header: String {
      return (token.tokenType ?? "") + " " + (token.savedToken ?? "")
    }
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var model: ProjectModel {
        return ProjectModel(title: projectName.value, color: chosenColor.value, ownerId: ownerId)
    }
    private var createRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.createProject(model: model, header: header)
    }
    private var fetchRequest: AnyPublisher<FetchProjectsResponceModel, NetworkError> {
        return projectService.fetchProjects(header: header)
    }
    private var updateRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.updateProject(model: model, header: header, projectId: selectedProjectId.value)
    }
    private var deleteRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.deleteProject(header: header, projectId: selectedProjectId.value)
    }
    
    init() {
        addSubscriptions()
    }
    
    func addSubscriptions() {
        
        fetchRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.objectWillChange.send()
                self?.projectsArray.value = item.data
            })
            .store(in: &cancellables)
        
        isPresented
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        isEditing
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        showAlert
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func fetchProjects() {
        fetchRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.objectWillChange.send()
                self?.projectsArray.value = item.data
            })
            .store(in: &cancellables)
    }
    
    func createProject() {
        createRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
                self?.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func updateProject() {
        updateRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
                self?.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func deleteProject() {
        deleteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchProjects()
            })
            .store(in: &cancellables)
    }
}
