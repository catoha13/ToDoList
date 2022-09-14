import Foundation
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
    private var publisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.createProject(model: model, header: header)
    }
    private var fetchPublisher: AnyPublisher<FetchProjectsResponceModel, NetworkError> {
        return projectService.fetchProjects(header: header)
    }
    private var updatePublisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.updateProject(model: model, header: header, projectId: selectedProject)
    }
    private var deletePublisher: AnyPublisher<ProjectResponceModel, NetworkError> {
        return projectService.deletePost(header: header, projectId: selectedProject)
    }
    
    func createProject() {
        publisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                print($0)
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func fetchProjects() {
        fetchPublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                self.projectsArray = $0.data
                print(self.projectsArray)
            })
            .store(in: &cancellables)
    }
    
    func updateProject() {
        updatePublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                print($0)
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
    
    func deleteProject() {
        deletePublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                print($0)
                self.fetchProjects()
            })
            .store(in: &cancellables)
    }
}
