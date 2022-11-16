import SwiftUI
import Combine

final class QuickViewModel: ObservableObject {
    
    @Published var mergedResponseArray: [(FetchAllNotesResponseData, ChecklistData, id: UUID)] = []
    
    //MARK: Note
    @Published var noteText = ""
    @Published var selectedNoteColor = ""
    @Published var selectedNote = ""
    @Published var isNoteCompleted = false
    
    @Published var isNoteEditing = false
    @Published var showNoteEditView = false
    @Published var showNoteAlert = false

    //MARK: Checklist
    @Published var checklistRequestArray: [ChecklistItemsModel] = []
    @Published var checklistResponseItems: [ChecklistItemsModel] = []
    @Published var checklistTitle = ""
    @Published var checklistColor = ""
    @Published var checklistItemId = ""
    @Published var newItemContent = ""
    @Published var isChecklistItemCompleted = false
    @Published var checklistId = ""
    
    @Published var selectedChecklist = [ChecklistItemsModel]()
    @Published var isChecklistEditing = false
    @Published var showChecklistEditView = false
    @Published var showChecklistAlert = false
    @Published var isAddItemEnabled = false
    
    //MARK: Network Alert
    @Published var alertMessage = ""
    @Published var showNetworkAlert = false
    
    private let user = User()
    private let notesNetworkService = NotesNetworkService()
    private let checklistsNetworkService = CheckListNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    //MARK: Note Models
    private var noteModel: NotesModel {
        NotesModel(description: noteText, color: selectedNoteColor, ownerId: ownerId, isCompleted: isNoteCompleted)
    }
    
    //MARK: Note Publishers
    let createNote = PassthroughSubject<Void, Never>()
    let deleteNote = PassthroughSubject<Void, Never>()
    let fetchOneNote = PassthroughSubject<Void, Never>()
    let fetchAllNotes = PassthroughSubject<Void, Never>()
    let updateNote = PassthroughSubject<Void, Never>()
    
    //MARK: Checklist Models
    private var updateItemsModel: [ChecklistItemsModel] {
        [ChecklistItemsModel(id: checklistItemId,content: newItemContent, isCompleted: isChecklistItemCompleted)]
    }
    private var updateChecklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: checklistTitle, color: checklistColor, ownerId: ownerId, items: updateItemsModel)
    }
    private var editChecklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: checklistTitle, color: checklistColor, ownerId: ownerId, items: checklistResponseItems)
    }
    private var checklistModel: ChecklistUpdateRequestModel {
        ChecklistUpdateRequestModel(title: checklistTitle, color: checklistColor, ownerId: ownerId, items: checklistRequestArray)
    }
    
    //MARK: Checklist Publishers
    let createChecklist = PassthroughSubject<Void, Never>()
    let updateChecklist = PassthroughSubject<Void, Never>()
    let editChecklist = PassthroughSubject<Void, Never>()
    let deleteChecklistItem = PassthroughSubject<Void, Never>()
    let deleteChecklist = PassthroughSubject<Void, Never>()
    let fetchOneChecklist = PassthroughSubject<Void, Never>()
    let fetchAllChecklists = PassthroughSubject<Void, Never>()
    
    init() {
        addSubscriptions()
        fetchNotesAndChecklists()
    }
    
    //MARK: Add Subsriptions
    private func addSubscriptions() {
        
        createNote
            .sink { [weak self] _ in
                self?.createNoteRequest()
            }
            .store(in: &cancellables)
        
        deleteNote
            .sink { [weak self] _ in
                self?.deleteNoteRequest()
            }
            .store(in: &cancellables)
        
        fetchOneNote
            .sink { [weak self] _ in
                self?.fetchOneNoteRequest()
            }
            .store(in: &cancellables)
        
        updateNote
            .sink { [weak self] _ in
                self?.updateNoteRequest()
            }
            .store(in: &cancellables)
        
        createChecklist
            .sink { [weak self] _ in
                self?.createChecklistRequest()
            }
            .store(in: &cancellables)
        
        updateChecklist
            .sink { [weak self] _ in
                self?.updateChecklistRequest()
            }
            .store(in: &cancellables)
        
        editChecklist
            .sink { [weak self] _ in
                self?.editChecklistRequest()
            }
            .store(in: &cancellables)
        
        deleteChecklistItem
            .sink { [weak self] _ in
                self?.deleteCheclistItemRequest()
            }
            .store(in: &cancellables)
        
        deleteChecklist
            .sink { [weak self] _ in
                self?.deleteChecklistRequest()
            }
            .store(in: &cancellables)
        
        fetchOneChecklist
            .sink { [weak self] _ in
                self?.fetchNotesAndChecklists()
            }
            .store(in: &cancellables)
    }
    
    //MARK: Fetch Notes & Checklists
    private func fetchNotesAndChecklists() {
        notesNetworkService.fetchAllNotes().zip(checklistsNetworkService.fetchAllChecklists())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            },
                  receiveValue: { [weak self] item in
                let notesData = item.0.data
                let checklistData = item.1.data
                let sortedNotes = notesData.sorted(by: {$0.createdAt > $1.createdAt} )
                let sortedChecklists = checklistData.sorted(by: { $0.createdAt > $1.createdAt} )
                var id = [UUID]()
                for _ in 0...sortedNotes.count + sortedChecklists.count {
                    id.append(UUID())
                }
                self?.mergedResponseArray = Array(zip(sortedNotes, sortedChecklists, id))
            })
            .store(in: &cancellables)
    }
    
    //MARK: Note funcs
    private func createNoteRequest() {
        notesNetworkService.createNote(model: noteModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func deleteNoteRequest() {
        notesNetworkService.deleteNote(noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func fetchOneNoteRequest() {
        notesNetworkService.fetchOneNote(noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func updateNoteRequest() {
        notesNetworkService.updateNotes(model: noteModel, noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchOneNote.send()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Checklist funcs
    private func createChecklistRequest() {
        checklistsNetworkService.createChecklist(model: checklistModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func updateChecklistRequest() {
        checklistsNetworkService.updateChecklist(model: updateChecklistModel, checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchOneChecklist.send()
            })
            .store(in: &cancellables)
    }
    
    private func editChecklistRequest() {
        checklistsNetworkService.updateChecklist(model: editChecklistModel, checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchOneChecklist.send()
            })
            .store(in: &cancellables)
    }
    
    private func deleteChecklistRequest() {
        checklistsNetworkService.deleteChecklist(checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func deleteCheclistItemRequest() {
        checklistsNetworkService.deleteChecklistItem(checklistItemId: checklistItemId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    private func fetchOneChecklistRequest() {
        checklistsNetworkService.fetchAllChecklists()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.showNetworkAlert = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
}
