import Combine

final class NotesNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    
    func createNote<T, U>(model: T, header: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.note.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func deleteNote<U>(header: String, noteId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneNote<U>( header: String, noteId: String) -> AnyPublisher<U, NetworkError> where U: Decodable {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchAllNotes<U>(header: String) -> AnyPublisher<U, NetworkError> where  U: Decodable {
        let path = Path.note.rawValue + "/" + (user.userId ?? "no data")
        return networkManager.get(path: path, header: header)
    }
    
    func updateNotes<T, U>(model: T, header: String, noteId: String) -> AnyPublisher<U, NetworkError> where T: Encodable, U: Decodable {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.put(body: model, path: path, header: header)
    }
}
