import SwiftUI
import Combine

final class MenuViewModel: ObservableObject {
    
    @Published var projectName = ""
    @Published var chosenColor = ""
    @Published var projectsArray: [FetchProjectsData] = []
    @Published var selectedProject = ""
    
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
    private var emptyModel: FetchProjectsResponceModel? = nil
    private var publisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.createProject(model: model, header: header)
    }
    private var fetchPublisher: AnyPublisher<FetchProjectsResponceModel, NetworkError> {
        return projectService.fetchProjects(model: emptyModel, header: header)
    }
    private var updatePublisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.updateProject(model: model, header: header, projectId: selectedProject)
    }
    private var deletePublisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.deletePost(header: header, projectId: selectedProject)
    }
    
    func createProject() {
        publisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func fetchProjects() {
        fetchPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: {
                self.projectsArray = $0.data
            })
            .store(in: &cancellables)
    }
    
    func updateProject() {
        updatePublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func deleteProject() {
        deletePublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
}
