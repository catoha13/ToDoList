import CoreData

struct TaskCoreDataManager {
    private let savedUser = User()
    private let context = CoreDataManager.shared.container
    private let fetchUsersRequest: NSFetchRequest<Users> = Users.fetchRequest()
    private let fetchTasksRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()

    //MARK: Load Tasks
    func loadTasks() -> [TaskResponseData] {
        do {
            let tasks = try context.viewContext.fetch(fetchTasksRequest)
            
            let userTasks = tasks.filter { $0.ownerId == savedUser.id }
            return userTasks.map { task in
                TaskResponseData(id: task.id ?? "",
                                 title: task.title ?? "",
                                 dueDate: task.dueDate ?? "",
                                 description: task.descriptions ?? "",
                                 assignedTo: task.assignedTo ?? "",
                                 isCompleted: task.isCompleted,
                                 projectId: task.projectId ?? "",
                                 ownerId: task.ownerId ?? "",
                                 createdAt: task.createdAt ?? "")
            }
        } catch {
            print("Cannot load the tasks \(error.localizedDescription)")
            return []
        }
    }
    
        //MARK: Save Task
    func saveTasks(from savedModels: TaskResponseData) {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            var userTasks = user?.tasks
           
                let task = Tasks(context: context.viewContext)
                var savedTasks: [Tasks] = []

                    task.id = savedModels.id
                    task.title = savedModels.title
                    task.dueDate = savedModels.dueDate
                    task.descriptions = savedModels.description
                    task.assignedTo = savedModels.assignedTo
                    task.isCompleted = savedModels.isCompleted
                    task.projectId = savedModels.projectId
                    task.ownerId = savedModels.ownerId
                    task.createdAt = savedModels.createdAt
                    task.user = user
                    
                    savedTasks.append(task)
            if let newTasks = userTasks {
                    userTasks = newTasks.addingObjects(from: savedTasks) as NSSet
                } else {
                    userTasks = Set(savedTasks) as NSSet
            }

            if context.viewContext.hasChanges {
                try context.viewContext.save()
            }
        } catch {
            print("Cannot save the tasks: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: Delete Task
    
    func deleteTasks() {
        do {
            let users = try context.viewContext.fetch(fetchUsersRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            
            let tasks = try context.viewContext.fetch(fetchTasksRequest)
            let userTasks = tasks.filter { $0.user == user }
            userTasks.forEach { task in
                context.viewContext.delete(task)
            }
        } catch {
            print("Cannot delete the tasks \(error.localizedDescription)")
        }
    }
}
