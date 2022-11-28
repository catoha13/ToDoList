import Combine

struct ProjectNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    func createProject(model: ProjectModel) -> AnyPublisher<ProjectResponceModel, NetworkError> {
        let path = Path.projects.rawValue
        return networkManager.post(body: model, path: path, header: token.header)
    }
    
    func fetchProjects() -> AnyPublisher<FetchProjectsResponceModel, NetworkError> {
        let path = Path.fetchProjects.rawValue + user.id
        return networkManager.get(path: path, header: token.header)
    }
    
    func updateProject(model: ProjectModel, projectId: String) -> AnyPublisher<ProjectResponceData, NetworkError> {
        let path = Path.projects.rawValue + "/" + projectId
        return networkManager.put(body: model, path: path, header: token.header)
    }
    
    func deleteProject(projectId: String) -> AnyPublisher<ProjectResponceModel, NetworkError> {
        let path = Path.projects.rawValue + "/" + projectId
        return networkManager.delete(path: path, header: token.header)
    }
}
