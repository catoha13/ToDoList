import Combine

struct NotesNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    func createNote(model: NotesModel) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue
        return networkManager.post(body: model, path: path, header: token.header)
    }
    
    func deleteNote(noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.delete(path: path, header: token.header)
    }
    
    func fetchOneNote(noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.get(path: path, header: token.header)
    }
    
    func fetchAllNotes() -> AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        let path = Path.fetchNotes.rawValue + "/" + user.id
        return networkManager.get(path: path, header: token.header)
    }
    
    func updateNotes(model: NotesModel, noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.put(body: model, path: path, header: token.header)
    }
}
