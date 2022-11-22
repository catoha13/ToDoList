import CoreData

struct ProjectCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
    
    func getAllProjects() -> [ProjectResponceData] {
        do {
            let projects = try container.viewContext.fetch(fetchRequest)
            return projects.map { project in
                ProjectResponceData(id: project.id?.uuidString,
                                     title: project.title,
                                     color: project.color,
                                     ownerId: project.ownerId?.uuidString,
                                    createdAt: DateFormatter.dateToString(project.createdAt ?? Date()))
            }
        } catch {
            print("Cannot load the projects \(error.localizedDescription)")
            return []
        }
    }
    
    func saveProjects(model: ProjectResponceData) {
        do {
            let project = Projects(context: container.viewContext)
            project.id = UUID(uuidString: model.id ?? "")
            project.title = model.title
            project.color = model.color
            project.ownerId = UUID(uuidString: model.ownerId ?? "")
            project.createdAt = DateFormatter.stringToDate(model.createdAt ?? "")
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the project \(error.localizedDescription)")
        }
    }
    
    func deleteProjects() {
        do {
            let projects = try container.viewContext.fetch(fetchRequest)
            projects.forEach { project in
                container.viewContext.delete(project)
            }
        } catch {
            print("Cannot delete the projects \(error.localizedDescription)")
        }
    }
}
