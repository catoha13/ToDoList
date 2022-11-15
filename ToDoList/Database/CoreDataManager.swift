import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoListCoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func getAllProjects() -> [Projects] {
        let fetchRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func saveProject(model: ProjectResponceData) {
        let project = Projects(context: container.viewContext)
        
        project.id = model.id
        project.title = model.title
        project.color = model.color
        project.owner_id = model.ownerId
        project.created_at = model.createdAt
        
        do {
            try container.viewContext.save()
        } catch {
            print("Cannot save the project \(error.localizedDescription)")
        }
    }
}
