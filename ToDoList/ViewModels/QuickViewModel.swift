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
    
    private let user = User()
    private var notesNetworkService = NotesNetworkService()
    private var checklistsNetworkService = CheckListNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var ownerId: String {
        return user.userId ?? "no data"
    }
    
    //MARK: Note Models
    private var noteModel: NotesModel {
        NotesModel(description: noteText, color: selectedNoteColor, ownerId: ownerId, isCompleted: isNoteCompleted)
    }
    
    //MARK: Note Models
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
        checklistsNetworkService.deleteChecklistItem(checklistItemId: checklistItemId)
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
    
    //MARK: Fetch Notes & Checklists
    private func fetchNotesAndChecklists() {
        fetchAllNotesRequest.zip(fetchAllChecklistsRequest)
            .sink(receiveCompletion: { _ in
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
                self?.fetchOneChecklist()
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


public func zip<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence
>(
  _ sequence1: Sequence1,
  _ sequence2: Sequence2,
  _ sequence3: Sequence3

) -> Zip3Sequence<
Sequence1,
Sequence2,
Sequence3
> {
  return Zip3Sequence(
    _sequence1: sequence1,
    _sequence2: sequence2,
    _sequence3: sequence3
  )
}

public struct Zip3Iterator<
  Iterator1 : IteratorProtocol,
  Iterator2 : IteratorProtocol,
  Iterator3 : IteratorProtocol
> : IteratorProtocol {
  public typealias Element = (
      Iterator1.Element,
      Iterator2.Element,
      Iterator3.Element
  )

  internal init(
      _ iterator1: Iterator1,
      _ iterator2: Iterator2,
      _ iterator3: Iterator3
  ) {
    _baseStream1 = iterator1
    _baseStream2 = iterator2
    _baseStream3 = iterator3
  }

  public mutating func next() -> Element? {

    if _reachedEnd {
      return nil
    }

    guard
        let element1 = _baseStream1.next(),
        let element2 = _baseStream2.next(),
        let element3 = _baseStream3.next()
    else {
      _reachedEnd = true
      return nil
    }

    return (
        element1,
        element2,
        element3
    )
  }

  internal var _baseStream1: Iterator1
  internal var _baseStream2: Iterator2
  internal var _baseStream3: Iterator3
  internal var _reachedEnd: Bool = false
}

public struct Zip3Sequence<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence
>
  : Sequence {

  public typealias Stream1 = Sequence1.Iterator
  public typealias Stream2 = Sequence2.Iterator
  public typealias Stream3 = Sequence3.Iterator

  public typealias Iterator = Zip3Iterator<
    Stream1,
    Stream2,
    Stream3
>

  @available(*, unavailable, renamed: "Iterator")
  public typealias Generator = Iterator


  public
  init(
    _sequence1 sequence1: Sequence1,
    _sequence2 sequence2: Sequence2,
    _sequence3 sequence3: Sequence3
  ) {
    _sequence1 = sequence1
    _sequence2 = sequence2
    _sequence3 = sequence3
  }

  public func makeIterator() -> Iterator {
    return Iterator(
      _sequence1.makeIterator(),
      _sequence2.makeIterator(),
      _sequence3.makeIterator()
    )
  }

  internal let _sequence1: Sequence1
  internal let _sequence2: Sequence2
  internal let _sequence3: Sequence3
}
