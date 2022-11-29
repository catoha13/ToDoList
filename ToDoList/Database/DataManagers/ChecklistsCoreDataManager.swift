import CoreData

struct ChecklistsCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchChecklistsRequest: NSFetchRequest<Checklists> = Checklists.fetchRequest()
    private let fetchChecklistItems: NSFetchRequest<ChecklistItems> = ChecklistItems.fetchRequest()
    
    func loadChecklists() -> [ChecklistData] {
        do {
            let checklistItems = try container.viewContext.fetch(fetchChecklistItems)
            let checklists = try container.viewContext.fetch(fetchChecklistsRequest)
            
            let convertItems = checklistItems.map {
                ChecklistItemsModel(id: String($0.id),
                                    content: $0.content ?? "",
                                    checklistId: String($0.checklistId),
                                    isCompleted: $0.isCompleted,
                                    createdAt: DateFormatter.dateToString($0.createdAt ?? Date() ))
            }
            
            return checklists.map { checklist in
                ChecklistData(id: String(checklist.id),
                              title: checklist.title ?? "",
                              color: checklist.color ?? "",
                              ownerId: String(checklist.ownerId),
                              items: convertItems.filter { $0.checklistId == String(checklist.id) },
                              createdAt: DateFormatter.dateToString(checklist.createdAt ?? Date())
                )}
            
        } catch {
            print("Cannot load the checklists \(error.localizedDescription)")
            return []
        }
    }
    
    func saveChecklist(model: ChecklistData) {
        do {
            let checklist = Checklists(context: container.viewContext)
            
            checklist.id = Int16(model.id) ?? 0
            checklist.title = model.title
            checklist.color = model.color
            checklist.ownerId = Int16(model.id) ?? 0
            checklist.checklistItem?.addingObjects(from: model.items)
            checklist.createdAt = DateFormatter.stringToDate(model.createdAt)
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the checklist \(error.localizedDescription)")
        }
    }
    
    func saveChecklistItems(model: ChecklistItemsModel) {
        do {
            let checklistItems = ChecklistItems(context: container.viewContext)
            
            checklistItems.id = Int16(model.id ?? "") ?? 0
            checklistItems.content = model.content
            checklistItems.isCompleted = model.isCompleted
            checklistItems.checklistId = Int16(model.checklistId ?? "") ?? 0
            checklistItems.createdAt = DateFormatter.stringToDate(model.createdAt ?? "")
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the checklist items \(error.localizedDescription)")
        }
    }
}
