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
    private var createPublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.createNote(model: model)
    }
    private var deletePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.deleteNote(noteId: selectedNote)
    }
    private var fetchOnePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.fetchOneNote(noteId: selectedNote)
    }
    private var fetchAllPublisher: AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        return notesService.fetchAllNotes()
    }
    private var updatePublisher: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesService.updateNotes(model: model, noteId: selectedNote)
    }
    
    func createNote() {
        createPublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func deleteNote() {
        deletePublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    
    func fetchOneNote() {
        fetchOnePublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchAllNotes()
            })
            .store(in: &cancellables)
    }
    func fetchAllNotes() {
        fetchAllPublisher
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
        updatePublisher
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchOneNote()
            })
            .store(in: &cancellables)
    }
    
    func convertColor(color: Color) -> String {
        var stringColor = color.description
        stringColor.removeLast()
        stringColor.removeLast()
        return stringColor
    }
    
}
