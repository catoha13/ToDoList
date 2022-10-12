import SwiftUI
import Combine

final class QuickViewModel: ObservableObject {
    
    @Published var mergedResponseArray: [(FetchAllNotesResponseData, ChecklistData)] = []
    
    //MARK: Note
    @Published var noteText = ""
    @Published var selectedColor = ""
    @Published var selectedNote = ""
    @Published var isNoteCompleted = false
    
    //MARK: Checklist
    @Published var checklistRequestArray: [ChecklistItemsModel] = []
    @Published var checklistResponseItems: [ChecklistItemsModel] = []
    @Published var title = ""
    @Published var color = ""
    @Published var itemId = ""
    @Published var newItemContent = ""
    @Published var isChecklistItemCompleted = false
    @Published var checklistId = ""
    
    private let user = User()
    private var notesNetworkService = NotesNetworkService()
    private var checklistsNetworkService = CheckListNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    //MARK: Note Publishers & Models
    private var noteModel: NotesModel {
        NotesModel(description: noteText, color: selectedColor, ownerId: ownerId, isCompleted: isNoteCompleted)
    }
    private var createNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        notesNetworkService.createNote(model: noteModel)
    }
    private var deleteNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        notesNetworkService.deleteNote(noteId: selectedNote)
    }
    private var fetchOneNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        notesNetworkService.fetchOneNote(noteId: selectedNote)
    }
    private var fetchAllNotesRequest: AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        notesNetworkService.fetchAllNotes()
    }
    private var updateNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        notesNetworkService.updateNotes(model: noteModel, noteId: selectedNote)
    }
    
    //MARK: Checklist Publishers & Models
    private var updateItemsModel: [ChecklistItemsModel] {
        [ChecklistItemsModel(id: itemId,content: newItemContent, isCompleted: isChecklistItemCompleted)]
    }
    private var updateChecklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: updateItemsModel)
    }
    private var editChecklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistResponseItems)
    }
    private var checklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistRequestArray)
    }
    
    private var createChecklistRequest: AnyPublisher<ChecklistUpdateRequestModel, NetworkError> {
        checklistsNetworkService.createChecklist(model: checklistModel)
    }
    
    private var updateChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        checklistsNetworkService.updateChecklist(model: updateChecklistModel, checklistId: checklistId)
    }
    private var editChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        checklistsNetworkService.updateChecklist(model: editChecklistModel, checklistId: checklistId)
    }
    
    private var deleteChecklistItemRequest: AnyPublisher<DeleteChecklistData, NetworkError> {
        checklistsNetworkService.deleteChecklistItem(checklistItemId: itemId)
    }
    
    private var deleteChecklistRequest: AnyPublisher<DeleteChecklistModel, NetworkError> {
        checklistsNetworkService.deleteChecklist(checklistId: checklistId)
    }
    
    private var fetchOneChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        checklistsNetworkService.fetchOneChecklist(checklistId: checklistId)
    }
    
    private var fetchAllChecklistsRequest: AnyPublisher<FetchAllChecklistsResponseModel, NetworkError> {
        checklistsNetworkService.fetchAllChecklists()
    }
    
    init() {
        fetchNotesAndChecklists()
    }
    
    private func fetchNotesAndChecklists() {
        fetchAllNotesRequest.zip(fetchAllChecklistsRequest)
            .sink(receiveCompletion: { _ in
            },
                  receiveValue: { [weak self] item in
                let notesData = item.0.data
                let checklistData = item.1.data
                let sortedNotes = notesData.sorted(by: {$0.createdAt > $1.createdAt} )
                let sortedChecklists = checklistData.sorted(by: { $0.createdAt > $1.createdAt} )
                self?.mergedResponseArray = Array(zip(sortedNotes, sortedChecklists))
            })
            .store(in: &cancellables)
    }
    
    //MARK: Note funcs
    func createNote() {
        createNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    func deleteNote() {
        deleteNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func fetchOneNote() {
        fetchOneNoteRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
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
    
    //MARK: Checklist funcs
    func createChecklist() {
        createChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    func updateChecklist() {
        updateChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchOneChecklist()
            })
            .store(in: &cancellables)
    }
    
    func editChecklist() {
        editChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    func deleteChecklist() {
        deleteChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchOneChecklist()
            })
            .store(in: &cancellables)
    }
    
    func deleteCheclistItem() {
        deleteChecklistItemRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func fetchOneChecklist() {
        fetchOneChecklistRequest
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
}
