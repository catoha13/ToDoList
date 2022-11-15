import SwiftUI
import Combine

final class MenuViewModel: ObservableObject {
    
    var isPresented = CurrentValueSubject<Bool, Never>(false)
    var isEditing = CurrentValueSubject<Bool, Never>(false)
    var showDeleteAlert = CurrentValueSubject<Bool, Never>(false)
    var showNetworkAlert = CurrentValueSubject<Bool, Never>(false)
    
    var alertMessage = CurrentValueSubject<String, Never>("")
    var projectName = CurrentValueSubject<String, Never>("")
    var chosenColor = CurrentValueSubject< String, Never>("")
    var projectsArray = CurrentValueSubject<[ProjectResponceData], Never>([])
    var selectedProjectId = CurrentValueSubject<String, Never>("")
    
    @Published var flexibleLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let user = User()
    private let projectService = ProjectNetworkService()
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private var model: ProjectModel {
        return ProjectModel(title: projectName.value, color: chosenColor.value, ownerId: user.userId ?? "")
    }
    
    let fetchProjectsRequest = PassthroughSubject<Void, Never>()
    let createProjectRequest = PassthroughSubject<Void, Never>()
    let updateProjectRequest = PassthroughSubject<Void, Never>()
    let deleteProjectRequest = PassthroughSubject<Void, Never>()
    
    init() {
        addSubscriptions()
        fetchProjectsRequest.send()
    }
    
    //MARK: Publishers
    private func addSubscriptions() {
        
        fetchProjectsRequest
            .sink { [weak self] _ in
                self?.fetchProjects()
            }
            .store(in: &cancellables)
        
        createProjectRequest
            .sink { [weak self] _ in
                self?.createProject()
            }
            .store(in: &cancellables)
        
        updateProjectRequest
            .sink { [weak self] _ in
                self?.updateProject()
            }
            .store(in: &cancellables)
        
        deleteProjectRequest
            .sink { [weak self] _ in
                self?.deleteProject()
            }
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
        
        showDeleteAlert
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        showNetworkAlert
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    //MARK: Funcs
    private func fetchProjects() {
        self.projectService.fetchProjects()
            .sink { [weak self] item in
                switch item {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage.value = error.description
                    self?.showNetworkAlert.value = true
                }
            } receiveValue: { [weak self] item in
                self?.objectWillChange.send()
                self?.projectsArray.value = item.data
            }
            .store(in: &self.cancellables)
    }
    
    private func createProject() {
        projectService.createProject(model: model)
            .sink { [weak self] item in
                switch item {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage.value = error.description
                    self?.showNetworkAlert.value = true
                }
            } receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
                self?.fetchProjectsRequest.send()
            }
            .store(in: &cancellables)
    }
    
    private func updateProject() {
        projectService.updateProject(model: model, projectId: selectedProjectId.value)
            .sink { [weak self] item in
                switch item {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage.value = error.description
                    self?.showNetworkAlert.value = true
                }
            } receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
                self?.fetchProjects()
            }
            .store(in: &cancellables)
    }
    
    private func deleteProject() {
        projectService.deleteProject(projectId: selectedProjectId.value)
            .sink { [weak self] item in
                switch item {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage.value = error.description
                    self?.showNetworkAlert.value = true
                }
            } receiveValue: { [weak self] _ in
                self?.fetchProjectsRequest.send()
            }
            .store(in: &cancellables)
    }
}
