import SwiftUI
import Combine

final class QuickViewModel: ObservableObject {
    
    @Published var mergedResponseArray: [(FetchAllNotesResponseData, ChecklistData)] = []
    
    //MARK: Note
    @Published var noteText = ""
    @Published var selectedColor = ""
    @Published var selectedNote = ""
    @Published var isNoteCompleted = false
    @Published var notesArray: [FetchAllNotesResponseData] = []
    
    //MARK: Checklist
    @Published var checklistRequestArray: [ChecklistItemsModel] = []
    @Published var checklistResponseArray: [ChecklistData] = []
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
    private var model: NotesModel {
        return NotesModel(description: noteText, color: selectedColor, ownerId: ownerId, isCompleted: isNoteCompleted)
    }
    private var createNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesNetworkService.createNote(model: model)
    }
    private var deleteNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesNetworkService.deleteNote(noteId: selectedNote)
    }
    private var fetchOneNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesNetworkService.fetchOneNote(noteId: selectedNote)
    }
    private var fetchAllNotesRequest: AnyPublisher<FetchAllNotesResponseModel, NetworkError> {
        return notesNetworkService.fetchAllNotes()
    }
    private var updateNoteRequest: AnyPublisher<NotesResponseModel, NetworkError> {
        return notesNetworkService.updateNotes(model: model, noteId: selectedNote)
    }
    
    //MARK: Checklist Publishers & Models
    private var updateItemsModel: [ChecklistItemsModel] {
        return [ChecklistItemsModel(id: itemId,content: newItemContent, isCompleted: isChecklistItemCompleted)]
    }
    private var updateModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: updateItemsModel)
    }
    private var editChecklistModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistResponseItems)
    }
    private var requestModel: ChecklistUpdateRequestModel {
        return ChecklistUpdateRequestModel(title: title, color: color, ownerId: ownerId, items: checklistRequestArray)
    }
    
    private var createChecklistRequest: AnyPublisher<ChecklistUpdateRequestModel, NetworkError> {
        return checklistsNetworkService.createChecklist(model: requestModel)
    }
    
    private var updateChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        return checklistsNetworkService.updateChecklist(model: updateModel, checklistId: checklistId)
    }
    private var editChecklistRequest: AnyPublisher<ChecklistResponseModel, NetworkError> {
        return checklistsNetworkService.updateChecklist(model: editChecklistModel, checklistId: checklistId)
    }
    
    private var deleteChecklistItemRequest: AnyPublisher<DeleteChecklistData, NetworkError> {
        return checklistsNetworkService.deleteChecklistItem(checklistItemId: itemId)
    }
    
    private var deleteChecklistRequest: AnyPublisher<DeleteChecklistModel, NetworkError> {
        return checklistsNetworkService.deleteChecklist(checklistId: checklistId)
    }
    
    private var fetchAllChecklistsRequest: AnyPublisher<FetchAllChecklistsResponseModel, NetworkError> {
        return checklistsNetworkService.fetchAllChecklists()
    }
    
    init() {
        fetchNotesAndChecklists()
    }
    
    private func fetchNotesAndChecklists() {
        fetchAllNotesRequest.zip(fetchAllChecklistsRequest)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
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
    
    func fetchOneNote() {
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
                self?.fetchNotesAndChecklists()
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
                self?.updateChecklist()
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
}
