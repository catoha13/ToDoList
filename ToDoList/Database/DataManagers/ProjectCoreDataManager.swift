import CoreData

struct ProjectCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
    
    func getAllProjects() -> [ProjectResponceData] {
        do {
            let projects = try container.viewContext.fetch(fetchRequest)
            return projects.map { project in
                (ProjectResponceData(id: project.id, title: project.title, color: project.color, ownerId: project.ownerId, createdAt: project.createdAt))
            }
        } catch {
            print("Cannot load the projects \(error.localizedDescription)")
            return []
        }
    }
    
    func saveProjects(model: ProjectResponceData) {
        do {
            let project = Projects(context: container.viewContext)
            project.id = model.id
            project.title = model.title
            project.color = model.color
            project.ownerId = model.ownerId
            project.createdAt = model.createdAt
            
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
