import SwiftUI
import Combine

final class CreateNoteViewModel: ObservableObject {
    @Published var noteText = ""
    @Published var selectedColor = ""
    @Published var selectedNote = "" // bind to view
    
    private var token = Token()
    private let user = User()
    private var notesService = NotesNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var header: String {
      return (token.tokenType ?? "") + " " + (token.savedToken ?? "")
    }
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var model: NotesModel {
        return NotesModel(description: noteText, color: selectedColor, ownerId: ownerId)
    }
    private var fetchModel: FetchAllNotesData {
        return FetchAllNotesData(ownerId: ownerId)
    }
    private var emptyModel: FetchAllNotesModel? = nil
    
    private var createPublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.createNote(model: model, header: header)
    }
    private var deletePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.deleteNote(header: header)
    }
    private var fetchOnePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.fetchOneNote(model: emptyModel, header: header, noteId: selectedNote)
    }
    private var fetchAllPublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.fetchAllNotes(model: model, header: header)
    }
    private var updatePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.updateNotes(model: model, header: header, noteId: selectedNote)
    }
    
    func createNote() {
        createPublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("create publisher – \(error)")
                }
            }, receiveValue: {
                print("create publisher – \($0)")
            })
            .store(in: &cancellables)
    }
    func deleteNote() {
        deletePublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("delete publisher – \(error)")
                }
            }, receiveValue: {
                print("delete publisher – \($0)")
            })
            .store(in: &cancellables)
    }
    
    func fetchOneNote() {
        fetchOnePublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("fetch one publisher – \(error)")
                }
            }, receiveValue: {
                print("fetch one publisher – \($0)")
            })
            .store(in: &cancellables)
    }
    
    func fetchAllNotes() {
        fetchAllPublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("fetch all publisher – \(error)")
                }
            }, receiveValue: {
                print("fetch all publisher – \($0)")
            })
            .store(in: &cancellables)
    }
    
    func updateNote() {
        updatePublisher
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print("update publisher – \(error)")
                }
            }, receiveValue: {
                print("update publisher – \($0)")
            })
            .store(in: &cancellables)
    }
}
