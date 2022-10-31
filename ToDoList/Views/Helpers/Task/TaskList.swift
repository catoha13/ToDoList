import SwiftUI
import Foundation

struct TaskList: View {
    @Binding var userTasks: [TaskResponseData]
    @Binding var filterCompletedTasks: Bool?
    @Binding var showTask: Bool

    @Binding var taskTitle: String
    @Binding var taskId: String
    @Binding var taskDueDate: String
    @Binding var taskDescription: String
    @Binding var taskAssigned_to: String
    @Binding var taskProjectId: String
//    @Binding var attachments:
    @Binding var members: [Members]?
    @Binding var membersUrl: [String]
    
    @State var deteleAction: () -> ()
    
    @State private var showAlert = false
    
    var body: some View {
        List {
            ForEach(userTasks, id: \.self) { task in
                if task.isCompleted == filterCompletedTasks {
                    TaskCell(title: task.title,
                             time: task.dueDate,
                             isDone: task.isCompleted,
                             editAction: {
                        withAnimation(.default) {
                            taskId = task.id
                            taskTitle = task.title
                            taskDueDate = task.dueDate
                            taskDescription = task.description
                            taskAssigned_to = task.assignedTo
                            taskProjectId = task.projectId
                            members = task.members
                            for user in members ?? [] {
                                membersUrl.append(user.avatarUrl)
                            }
                            showTask.toggle()
                        }
                    },
                             deleteAction: {
                        taskId = task.id
                        taskTitle = task.title
                        showAlert.toggle()
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Delete «\(taskTitle)»?"),
                              message: Text("You cannot undo this action"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete")) {
                            userTasks.removeAll(where: {$0.id == taskId})
                            deteleAction()
                        })
                    }
                    .listRowSeparator(.hidden)
                    
                } else if filterCompletedTasks == nil {
                    TaskCell(title: task.title,
                             time: task.dueDate,
                             isDone: task.isCompleted,
                             editAction: {
                        withAnimation(.default) {
                            taskId = task.id
                            taskTitle = task.title
                            taskDueDate = task.dueDate
                            taskDescription = task.description
                            taskAssigned_to = task.assignedTo
                            taskProjectId = task.projectId
                            members = task.members
                            for user in members ?? [] {
                                membersUrl.append(user.avatarUrl)
                            }
                            showTask.toggle()
                        }
                    },
                             deleteAction: {
                        taskId = task.id
                        taskTitle = task.title
                        showAlert.toggle()
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Delete «\(taskTitle)»?"),
                              message: Text("You cannot undo this action"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete")) {
                            userTasks.removeAll(where: {$0.id == taskId})
                            deteleAction()
                        })
                    }
                    .listRowSeparator(.hidden)
                }
            }
  
        }
        .animation(.default, value: userTasks)
        .background(Color.customWhiteBackground.ignoresSafeArea())
        .scrollContentBackground(.hidden)
        .padding(.top, -8)
    }
}

struct TaskList_Previews: PreviewProvider {
    @State static var userTasks: [TaskResponseData] = []
    @State static var filterTask: Bool? = false
    @State static var showTaskCompletion = false
    
    @State static var taskTitle = ""
    @State static var taskId = ""
    @State static var dueDate = ""
    @State static var description = ""
    @State static var assigned_to = ""
    @State static var projectId = ""
    @State static var members: [Members]? = []
    
    @State static var membersUrls: [String] = []
    
    static var previews: some View {
        TaskList(userTasks: $userTasks,
                 filterCompletedTasks: $filterTask,
                 showTask: $showTaskCompletion,
                 taskTitle: $taskTitle,
                 taskId: $taskId,
                 taskDueDate: $dueDate,
                 taskDescription: $description,
                 taskAssigned_to: $assigned_to,
                 taskProjectId: $projectId,
                 members: $members,
                 membersUrl: $membersUrls,
                 deteleAction: {})
    }
}
