import SwiftUI
import Combine

final class MenuViewModel: ObservableObject {
    
    @Published var isPresented = false
    @Published var isEditing = false
    @Published var showAlert = false
    @Published var selectedColor = ""
    
    @Published var projectName = ""
    @Published var chosenColor = ""
    @Published var projectsArray: [FetchProjectsData] = []
    @Published var selectedProject = ""
    
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
        return ProjectModel(title: projectName, color: chosenColor, ownerId: ownerId)
    }
    private var createRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.createProject(model: model, header: header)
    }
    private var fetchRequest: AnyPublisher<FetchProjectsResponceModel, NetworkError> {
        return projectService.fetchProjects(header: header)
    }
    private var updateRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.updateProject(model: model, header: header, projectId: selectedProject)
    }
    private var deleteRequest: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.deletePost(header: header, projectId: selectedProject)
    }
    
    init() {
        fetchProjects()
    }
    
    func createProject() {
        createRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    private func fetchProjects() {
        fetchRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.projectsArray = item.data
            })
            .store(in: &cancellables)
    }
    
    func updateProject() {
        updateRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
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
