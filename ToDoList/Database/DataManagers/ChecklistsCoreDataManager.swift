import CoreData

struct ChecklistsCoreDataManager {
    private let savedUser = User()
    private let context = CoreDataManager.shared.container
    private let fetchChecklistsRequest: NSFetchRequest<Checklists> = Checklists.fetchRequest()
    private let fetchChecklistItems: NSFetchRequest<ChecklistItems> = ChecklistItems.fetchRequest()
    private let fetchUsersRequest: NSFetchRequest<Users> = Users.fetchRequest()
    
    func loadChecklists() -> [ChecklistData] {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            let savedChecklistItems = try context.viewContext.fetch(fetchChecklistItems)
            let savedChecklists = try context.viewContext.fetch(fetchChecklistsRequest)
            let userChecklists = savedChecklists.filter { $0.user == user }
                        
            let checklistItems = savedChecklistItems.map {
                ChecklistItemsModel(id: $0.id ?? "",
                                    content: $0.content ?? "",
                                    checklistId: $0.checklistId,
                                    isCompleted: $0.isCompleted,
                                    createdAt: $0.createdAt ?? "")
            }
            
            return userChecklists.map { checklist in
                ChecklistData(id: checklist.id ?? "",
                              title: checklist.title ?? "",
                              color: checklist.color ?? "",
                              ownerId: checklist.ownerId ?? "",
                              items: checklistItems.filter { $0.checklistId == checklist.id },
                              createdAt: checklist.createdAt ?? ""
                )}
            
        } catch {
            print("Cannot load the checklists \(error.localizedDescription)")
            return []
        }
    }
    
    func saveChecklist(model: ChecklistData) {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            let checklist = Checklists(context: context.viewContext)
            let checklistItem = ChecklistItems(context: context.viewContext)
            var userChecklists = user?.checklists
            var userchecklistItems = checklist.checklistItems
            var saveChecklists: [Checklists] = []
            var saveChecklistsItems: [ChecklistItems] = []
            
            model.items.forEach { item in
                checklistItem.id = item.id
                checklistItem.content = item.content
                checklistItem.isCompleted = item.isCompleted
                checklistItem.checklistId = item.checklistId
                checklistItem.createdAt = item.createdAt
                checklistItem.checklist = checklist
                saveChecklistsItems.append(checklistItem)
            }

            if let newChecklistItems = userchecklistItems {
                userchecklistItems = newChecklistItems.addingObjects(from: saveChecklistsItems) as NSSet
            } else {
                userchecklistItems = Set(saveChecklistsItems) as NSSet
            }
            
            checklist.id = model.id
            checklist.title = model.title
            checklist.color = model.color
            checklist.ownerId = model.id
            checklist.checklistItems?.addingObjects(from: model.items)
            checklist.createdAt = model.createdAt
            checklist.user = user
            
            saveChecklists.append(checklist)
            
            if let newChecklists = userChecklists {
                userChecklists = newChecklists.addingObjects(from: saveChecklists) as NSSet
            } else {
                userChecklists = Set(saveChecklists) as NSSet
            }
            
            if context.viewContext.hasChanges {
                try context.viewContext.save()
            }
        } catch {
            print("Cannot save the checklist \(error.localizedDescription)")
        }
    }
    
    func deleteChecklist() {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            
            let checklists = try context.viewContext.fetch(fetchChecklistsRequest)
            let userChecklists = checklists.filter { $0.user == user }
            userChecklists.forEach { checklist in
                context.viewContext.delete(checklist)
            }
        } catch {
            print("Cannot delete the checklists \(error.localizedDescription)")
        }
    }
}
