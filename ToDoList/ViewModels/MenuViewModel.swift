import SwiftUI
import Combine

final class MenuViewModel: ObservableObject {
    
    var showCreateProject = CurrentValueSubject<Bool, Never>(false)
    var isEditing = CurrentValueSubject<Bool, Never>(false)
    var showDeleteAlert = CurrentValueSubject<Bool, Never>(false)
    
    var projectName = CurrentValueSubject<String, Never>("")
    var chosenColor = CurrentValueSubject< String, Never>("")
    var projectsArray = CurrentValueSubject<[ProjectResponceData], Never>([])
    var selectedProjectId = CurrentValueSubject<String, Never>("")
    
    var alertMessage = CurrentValueSubject<String, Never>("")
    var showNetworkAlert = CurrentValueSubject<Bool, Never>(false)

    
    @Published var flexibleLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let user = User()
    private let projectService = ProjectNetworkService()
    private let projectCoreDataManager = ProjectCoreDataManager()
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
        
        showCreateProject
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
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    guard let self = self else { return }
                    self.alertMessage.value = error.description
                    self.showNetworkAlert.value = true
                    self.projectsArray.value = self.projectCoreDataManager.getAllProjects()
                }
            } receiveValue: { [weak self] item in
                guard let self = self else { return }
                self.objectWillChange.send()
                if item.data != self.projectCoreDataManager.getAllProjects() {
                    self.projectCoreDataManager.deleteProjects()
                    item.data.forEach { project in
                        self.projectCoreDataManager.saveProjects(model: project)
                    }
                }
                self.projectsArray.value = item.data
            }
            .store(in: &self.cancellables)
    }
    
    private func createProject() {
        projectService.createProject(model: model)
            .sink { [weak self] completion in
                switch completion {
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
            .sink { [weak self] completion in
                switch completion {
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
    
    private func deleteProject() {
        projectService.deleteProject(projectId: selectedProjectId.value)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    guard let self = self else { return }
                    self.alertMessage.value = error.description
                    self.showNetworkAlert.value = true
                }
            } receiveValue: { [weak self] _ in
                self?.fetchProjectsRequest.send()
            }
            .store(in: &cancellables)
    }
}
