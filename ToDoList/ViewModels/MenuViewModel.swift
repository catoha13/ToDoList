import Foundation
import Combine

final class MenuViewModel: ObservableObject {
    
    @Published var projectName = ""
    @Published var chosenColor = ""
    @Published var projectsArray: [FetchProjectsData] = []
    
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
    
    func createProject() {
        publisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    // alert with error
                    print(error.description)
                }
            }, receiveValue: {
                print($0)
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
                    // alert with error
                    print(error.description)
                }
            }, receiveValue: {
                self.projectsArray = $0.data
                print(self.projectsArray[0])
            })
            .store(in: &cancellables)
    }
    
}
