import CoreData

struct NotesCoreDataManager {
    private let savedUser = User()
    private let context = CoreDataManager.shared.container
    private let fetchNotesRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    private let fetchUsersRequest: NSFetchRequest<Users> = Users.fetchRequest()
    
    func loadNotes() -> [NotesResponseData] {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            let notes = try context.viewContext.fetch(fetchNotesRequest)
            let savedUserNotes = notes.filter { $0.user == user }
            return savedUserNotes.map { NotesResponseData(id: $0.id ?? "",
                                                 description: $0.descriptions ?? "",
                                                 color: $0.color ?? "",
                                                 ownerId: $0.ownerId ?? "",
                                                 isCompleted: $0.isCompleted,
                                                 createdAt: $0.createdAt ?? ""
            )}
            
        } catch {
            print("Cannot load the notes \(error.localizedDescription)")
            return []
        }
    }
    
    func saveNote(model: NotesResponseData) {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            var userNotes = user?.notes
            
            let note = Notes(context: context.viewContext)
            var saveNotes: [Notes] = []
            
            note.id = model.id
            note.descriptions = model.description
            note.color = model.color
            note.ownerId = model.ownerId
            note.isCompleted = model.isCompleted ?? false
            note.createdAt = model.createdAt
            note.user = user
            
            saveNotes.append(note)
            
            if let newNotes = userNotes {
                userNotes = newNotes.addingObjects(from: saveNotes) as NSSet
            } else {
                userNotes = Set(saveNotes) as NSSet
            }
            
            if context.viewContext.hasChanges {
                try context.viewContext.save()
            }
        } catch {
            print("Cannot save the note \(error.localizedDescription)")
        }
    }
    
    func deleteNotes() {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            
            let notes = try context.viewContext.fetch(fetchNotesRequest)
            let userNotes = notes.filter { $0.user == user }
            userNotes.forEach { note in
                context.viewContext.delete(note)
            }
        } catch {
            print("Cannot delete the notes \(error.localizedDescription)")
        }
    }
}
