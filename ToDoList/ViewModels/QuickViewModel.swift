import SwiftUI
import Combine

final class QuickViewModel: ObservableObject {
    
    @Published var mergedResponseArray: [NotesAndChecklists] = []
    
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
    @Published var isOffline = false
    
    private let user = User()
    private let notesNetworkService = NotesNetworkService()
    private let checklistsNetworkService = CheckListNetworkService()
    private let notesDataStorage = NotesCoreDataManager()
    private let checklistsDataStorage = ChecklistsCoreDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Note Models
    private var createNoteModel: CreateNoteModel {
        .init(description: noteText,
              color: selectedNoteColor,
              ownerId: user.id)
    }
    private var noteModel: NotesModel {
        .init(description: noteText,
              color: selectedNoteColor,
              ownerId: user.id,
              isCompleted: isNoteCompleted)
    }
    
    //MARK: Note Publishers
    let createNote = PassthroughSubject<Void, Never>()
    let deleteNote = PassthroughSubject<Void, Never>()
    let fetchOneNote = PassthroughSubject<Void, Never>()
    let fetchAllNotes = PassthroughSubject<Void, Never>()
    let updateNote = PassthroughSubject<Void, Never>()
    
    //MARK: Checklist Models
    private var updateItemsModel: [ChecklistItemsModel] {
        [.init(id: checklistItemId,
               content: newItemContent,
               isCompleted: isChecklistItemCompleted)]
    }
    private var updateChecklistModel: ChecklistRequestsModel {
        .init(title: checklistTitle,
              color: checklistColor,
              ownerId: user.id,
              items: updateItemsModel)
    }
    private var editChecklistModel: ChecklistRequestsModel {
        .init(title: checklistTitle,
              color: checklistColor,
              ownerId: user.id,
              items: checklistResponseItems)
    }
    private var checklistModel: ChecklistRequestsModel {
        .init(title: checklistTitle,
              color: checklistColor,
              ownerId: user.id,
              items: checklistRequestArray)
    }
    
    //MARK: Checklist Publishers
    let createChecklist = PassthroughSubject<Void, Never>()
    let updateChecklist = PassthroughSubject<Void, Never>()
    let editChecklist = PassthroughSubject<Void, Never>()
    let deleteChecklistItem = PassthroughSubject<Void, Never>()
    let deleteChecklist = PassthroughSubject<Void, Never>()
    let fetchOneChecklist = PassthroughSubject<Void, Never>()
    let fetchAllChecklists = PassthroughSubject<Void, Never>()
    
    //MARK: Initialization
    init() {
        addSubscriptions()
        fetchNotesAndChecklists()
        print("QuickViewModel initialized")
    }
    
    deinit {
        print("QuickViewModel deinitialized")
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
    func fetchNotesAndChecklists() {
        notesNetworkService.fetchAllNotes().zip(checklistsNetworkService.fetchAllChecklists())
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    guard let self = self else { return }
                    self.alertMessage = error.description
                    self.isOffline = true
                    self.notesDataStorage.loadNotes().forEach { note in
                        let loadedNotes: NotesAndChecklists = .notes(note)
                        self.mergedResponseArray.append(loadedNotes)
                    }
                    self.checklistsDataStorage.loadChecklists().forEach { checklist in
                        let loadedChecklists: NotesAndChecklists = .checklists(checklist)
                        self.mergedResponseArray.append(loadedChecklists)
                    }
                }
            },
                  receiveValue: { [weak self] item in
                guard let self = self else { return }
                self.objectWillChange.send()
                self.mergedResponseArray.removeAll()
                
                let notes = item.0.data.sorted(by: { $0.createdAt ?? "" > $1.createdAt ?? ""})
                notes.forEach { note in
                    let loadedNotes: NotesAndChecklists = .notes(note)
                    self.mergedResponseArray.append(loadedNotes)
                    if notes != self.notesDataStorage.loadNotes() {
                        self.notesDataStorage.deleteNotes()
                        notes.forEach {
                            self.notesDataStorage.saveNote(model: $0)
                        }
                    }
                }
                let checklists = item.1.data.sorted(by: { $0.createdAt > $1.createdAt})
                checklists.forEach { checklist in
                    let loadedChecklists: NotesAndChecklists = .checklists(checklist)
                    self.mergedResponseArray.append(loadedChecklists)
                    if checklists != self.checklistsDataStorage.loadChecklists() {
                        self.checklistsDataStorage.deleteChecklist()
                        checklists.forEach {
                            self.checklistsDataStorage.saveChecklist(model: $0)
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    //MARK: Create Note
    private func createNoteRequest() {
        notesNetworkService.createNote(model: createNoteModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Delete Note
    private func deleteNoteRequest() {
        notesNetworkService.deleteNote(noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Fetch One Note
    private func fetchOneNoteRequest() {
        notesNetworkService.fetchOneNote(noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Update Note
    private func updateNoteRequest() {
        notesNetworkService.updateNotes(model: noteModel, noteId: selectedNote)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Create Checklist
    private func createChecklistRequest() {
        checklistsNetworkService.createChecklist(model: checklistModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Update Checklist
    private func updateChecklistRequest() {
        checklistsNetworkService.updateChecklist(model: updateChecklistModel, checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchOneChecklist.send()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Edit Checklist
    private func editChecklistRequest() {
        checklistsNetworkService.updateChecklist(model: editChecklistModel, checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] item in
                self?.fetchOneChecklist.send()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Delete Checklist
    private func deleteChecklistRequest() {
        checklistsNetworkService.deleteChecklist(checklistId: checklistId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Delete Checklist Item
    private func deleteCheclistItemRequest() {
        checklistsNetworkService.deleteChecklistItem(checklistItemId: checklistItemId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
    
    //MARK: Fetch One Checklist
    private func fetchOneChecklistRequest() {
        checklistsNetworkService.fetchAllChecklists()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.alertMessage = error.description
                    self?.isOffline = true
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchNotesAndChecklists()
            })
            .store(in: &cancellables)
    }
}

enum NotesAndChecklists: Hashable, Identifiable {
    case notes (NotesResponseData)
    case checklists (ChecklistData)
}
