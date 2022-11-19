import Combine

struct NotesNetworkService {
    private let networkManager = NetworkMaganer.shared
    private let user = User()
    private let token = Token()
    
    private var header: String {
        return (token.tokenType ?? "") + " " + (token.savedToken ?? "")
    }
    
    func createNote(model: NotesModel) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue
        return networkManager.post(body: model, path: path, header: header)
    }
    
    func deleteNote(noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.delete(path: path, header: header)
    }
    
    func fetchOneNote(noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.get(path: path, header: header)
    }
    
    func fetchAllNotes() -> AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        let path = Path.fetchNotes.rawValue + "/" + (user.userId ?? "no data")
        return networkManager.get(path: path, header: header)
    }
    
    func updateNotes(model: NotesModel, noteId: String) -> AnyPublisher<NotesResponseModel, NetworkError> {
        let path = Path.note.rawValue + "/" + noteId
        return networkManager.put(body: model, path: path, header: header)
    }
}
