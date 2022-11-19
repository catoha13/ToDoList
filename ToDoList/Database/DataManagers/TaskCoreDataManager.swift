import CoreData

struct TaskCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchTasksRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()

    //MARK: Load Tasks
    func loadTasks() -> [TaskResponseData] {
        do {
            let tasks = try container.viewContext.fetch(fetchTasksRequest)
            return tasks.map { TaskResponseData(id: $0.id ?? "",
                                                title: $0.title ?? "",
                                                dueDate: $0.dueDate ?? "",
                                                description: $0.descriptions ?? "",
                                                assignedTo: $0.assignedTo ?? "",
                                                isCompleted: $0.isCompleted,
                                                projectId: $0.projectId ?? "",
                                                ownerId: $0.ownerId ?? "",
                                                createdAt: $0.createdAt ?? ""
            )}
            
        } catch {
            print("Cannot load the tasks \(error.localizedDescription)")
            return []
        }
    }
    
        //MARK: Save Task
    func saveTask(model: TaskResponseData) {
        do {
            let task = Tasks(context: container.viewContext)
            
            task.id = model.id
            task.title = model.title
            task.dueDate = model.dueDate
            task.descriptions = model.description
            task.assignedTo = model.assignedTo
            task.isCompleted = model.isCompleted
            task.projectId = model.projectId
            task.ownerId = model.ownerId
            task.createdAt = model.createdAt
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the tasks \(error.localizedDescription)")
        }
    }
    
    
    //MARK: Delete Task
    func deleteTasks() {
        do {
            let tasks = try container.viewContext.fetch(fetchTasksRequest)
            tasks.forEach { project in
                container.viewContext.delete(project)
            }
        } catch {
            print("Cannot delete the tasks \(error.localizedDescription)")
        }
    }
    
}
