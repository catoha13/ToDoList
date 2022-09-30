import SwiftUI
import Combine

final class CreateNoteViewModel: ObservableObject {
    @Published var noteText = ""
    @Published var selectedColor = ""
    @Published var selectedNote = ""
    @Published var isCompleted = false
    @Published var notesArray: [FetchAllNotesResponseData] = []
    
    private let user = User()
    private var notesService = NotesNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    private var model: NotesModel {
        return NotesModel(description: noteText, color: selectedColor, ownerId: ownerId, isCompleted: isCompleted)
    }
    private var createRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.createNote(model: model)
    }
    private var deleteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.deleteNote(noteId: selectedNote)
    }
    private var fetchOneRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.fetchOneNote(noteId: selectedNote)
    }
    private var fetchAllRequest: AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        return notesService.fetchAllNotes()
    }
    private var updateRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.updateNotes(model: model, noteId: selectedNote)
    }
    
    func createNote() {
        createRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func deleteNote() {
        deleteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func fetchOneNote() {
        fetchOneRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    func fetchAllNotes() {
        fetchAllRequest
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
        updateRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchOneNote()
            })
            .store(in: &cancellables)
    }    
}
