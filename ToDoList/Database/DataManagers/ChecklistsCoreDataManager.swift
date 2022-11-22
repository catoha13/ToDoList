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
            
            return checklists.map { ChecklistData(id: String($0.id),
                                             title: $0.title ?? "",
                                             color: $0.color ?? "",
                                             ownerId: String($0.ownerId),
                                             items: convertItems,
                                                  createdAt: DateFormatter.dateToString($0.createdAt ?? Date())
            )}
            
        } catch {
            print("Cannot load the tasks \(error.localizedDescription)")
            return []
        }
    }
}
