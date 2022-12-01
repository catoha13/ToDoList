import CoreData

struct ProjectCoreDataManager {
    private let savedUser = User()
    private let context = CoreDataManager.shared.container
    private let fetchProjectsRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
    private let fetchUsersRequest: NSFetchRequest<Users> = Users.fetchRequest()
    
    //MARK: Load Projects
    func loadProjects() -> [ProjectResponceData] {
        do {
            let projects = try context.viewContext.fetch(fetchProjectsRequest)
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            let userProjects = projects.filter { $0.user == user }
            
            return userProjects.map { project in
                ProjectResponceData(id: project.id?.uuidString,
                                    title: project.title,
                                    color: project.color,
                                    ownerId: project.ownerId?.uuidString,
                                    createdAt: project.createdAt ?? "")
            }
        } catch {
            print("Cannot load the projects \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: Save Projects
    func saveProjects(model: ProjectResponceData) {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            var userProjects = user?.projects
            
            let project = Projects(context: context.viewContext)
            var savedProjects: [Projects] = []
            
            project.id = UUID(uuidString: model.id ?? "")
            project.title = model.title
            project.color = model.color
            project.ownerId = UUID(uuidString: model.ownerId ?? "")
            project.createdAt = model.createdAt ?? ""
            project.user = user
            
            savedProjects.append(project)
            if let newProjects = userProjects {
                userProjects = newProjects.addingObjects(from: savedProjects) as NSSet
            } else {
                userProjects = Set(savedProjects) as NSSet
            }
            
            if context.viewContext.hasChanges {
                try context.viewContext.save()
            }
        } catch {
            print("Cannot save the project \(error.localizedDescription)")
        }
    }
    
    //MARK: Delete Projects
    func deleteProjects() {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            
            let projects = try context.viewContext.fetch(fetchProjectsRequest)
            let userProjects = projects.filter { $0.user == user }
            userProjects.forEach { project in
                context.viewContext.delete(project)
            }
        } catch {
            print("Cannot delete the projects \(error.localizedDescription)")
        }
    }
}
