import CoreData

struct NotesCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchNotesRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    
    func loadNotes() -> [NotesResponseData] {
        do {
            let notes = try container.viewContext.fetch(fetchNotesRequest)
            return notes.map { NotesResponseData(id: String($0.id),
                                                 description: $0.descriptions,
                                                 color: $0.color,
                                                 ownerId: $0.ownerId?.uuidString,
                                                 isCompleted: $0.isCompleted,
                                                 createdAt: DateFormatter.dateToString($0.createdAt ?? Date())
            )}
            
        } catch {
            print("Cannot load the tasks \(error.localizedDescription)")
            return []
        }
    }
    
    func saveNote(model: NotesResponseData) {
        do {
            let note = Notes(context: container.viewContext)
            
            note.id = Int16(model.id ?? "") ?? 0
            note.descriptions = model.description
            note.color = model.color
            note.ownerId = UUID(uuidString: model.ownerId ?? "")
            note.isCompleted = model.isCompleted ?? false
            note.createdAt = DateFormatter.stringToDate(model.createdAt ?? "")
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the task \(error.localizedDescription)")
        }
    }
}
