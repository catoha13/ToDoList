import SwiftUI
import Combine

final class NoteViewModel: ObservableObject {
    @Published var noteText = ""
    @Published var selectedColor = ""
    @Published var selectedNote = ""
    @Published var isCompleted = false
    @Published var notesArray: [FetchAllNotesResponseData] = []
    
    private let user = User()
    private var notesService = NotesNetworkService()
    private var networkService = CheckListNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var model: NotesModel {
        return NotesModel(description: noteText, color: selectedColor, ownerId: ownerId, isCompleted: isCompleted)
    }
    private var createNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.createNote(model: model)
    }
    private var deleteNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.deleteNote(noteId: selectedNote)
    }
    private var fetchOneNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.fetchOneNote(noteId: selectedNote)
    }
    private var fetchAllNotesRequest: AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        return notesService.fetchAllNotes()
    }
    private var updateNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.updateNotes(model: model, noteId: selectedNote)
    }
    
    func createNote() {
        createNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func deleteNote() {
        deleteNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func fetchOneNote() {
        fetchOneNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    func fetchAllNotes() {
        fetchAllNotesRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                let array = item.data
                self?.notesArray = array.sorted(by: { first, second in
                    first.createdAt > second.createdAt
                })
            })
            .store(in: &cancellables)
    }
    
    func updateNote() {
        updateNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchOneNote()
            })
            .store(in: &cancellables)
    }
}
