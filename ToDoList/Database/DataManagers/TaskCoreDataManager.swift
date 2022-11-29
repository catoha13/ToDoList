import CoreData

struct TaskCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchTasksRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()

    //MARK: Load Tasks
    func loadTasks() -> [TaskResponseData] {
        do {
            let tasks = try container.viewContext.fetch(fetchTasksRequest)
            return tasks.map { TaskResponseData(id: String($0.id),
                                                title: $0.title ?? "",
                                                dueDate: DateFormatter.dateToString($0.dueDate ?? Date() ),
                                                description: $0.descriptions ?? "",
                                                assignedTo: String($0.assignedTo),
                                                isCompleted: $0.isCompleted,
                                                projectId: String($0.projectId),
                                                ownerId: String($0.ownerId),
                                                createdAt: DateFormatter.dateToString($0.createdAt ?? Date() )
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
            
            task.id = Int16(model.id) ?? 0
            task.title = model.title
            task.dueDate = DateFormatter.stringToDate(model.dueDate)
            task.descriptions = model.description
            task.assignedTo = Int16(model.assignedTo) ?? 0
            task.isCompleted = model.isCompleted
            task.projectId = Int16(model.projectId) ?? 0
            task.ownerId = Int16(model.ownerId) ?? 0
            task.createdAt = DateFormatter.stringToDate(model.createdAt)
            
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
