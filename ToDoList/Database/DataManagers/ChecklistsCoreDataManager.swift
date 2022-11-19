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
                ChecklistItemsModel(id: $0.id, content: $0.content ?? "", checklistId: $0.checklistId, isCompleted: $0.isCompleted, createdAt: $0.createdAt)
            }
            
            return checklists.map { ChecklistData(id: $0.id ?? "",
                                             title: $0.title ?? "",
                                             color: $0.color ?? "",
                                             ownerId: $0.ownerId ?? "",
                                             items: convertItems,
                                             createdAt: $0.createdAt ?? ""
            )}
            
        } catch {
            print("Cannot load the tasks \(error.localizedDescription)")
            return []
        }
    }
}
