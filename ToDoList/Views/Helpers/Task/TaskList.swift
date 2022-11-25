import SwiftUI
import Foundation

struct TaskList: View {
    @Binding var userTasks: [TaskResponseData]
    @Binding var filterCompletedTasks: CompletedType
    @Binding var showTask: Bool
    @Binding var isTaskCompleted: Bool
    @Binding var taskTitle: String
    @Binding var taskId: String
    @Binding var taskDueDate: String
    @Binding var taskDescription: String
    @Binding var taskAssigned_to: String
    @Binding var taskProjectId: String
    @Binding var members: [Member]?
    @Binding var membersUrl: [String]
    
    @State var deteleAction: () -> ()
    
    @State private var showAlert = false
    
    private var groupedByDate: [String : [TaskResponseData]] {
        switch filterCompletedTasks {
        case .all:
           return Dictionary(grouping: userTasks, by: { DateFormatter.trimDate($0.dueDate) })
        case .notCompleted:
            return Dictionary(grouping: userTasks.filter { false == $0.isCompleted }, by: { DateFormatter.trimDate($0.dueDate) })
        case .completed:
           return Dictionary(grouping: userTasks.filter { true == $0.isCompleted }, by: { DateFormatter.trimDate($0.dueDate) })
        }

    }
    private var headers: [String] {
        groupedByDate.map { $0.key }
    }
    
    var body: some View {
        List {
            ForEach(headers.sorted {$0 > $1} , id: \.self) { header in
                Section(header: Text(header)
                    .font(.RobotoThinItalicSmall)
                    .padding(.leading)) {
                        ForEach(groupedByDate[header] ?? [], id: \.self) { task in
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
                                    isTaskCompleted = task.isCompleted
                                    showTask.toggle()
                                }
                            },
                                     deleteAction: {
                                taskId = task.id
                                taskTitle = task.title
                                showAlert.toggle()
                            })
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Delete") + Text(" «\(taskTitle)»?"),
                                      message: Text("You cannot undo this action"),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(Text("Delete")) {
                                    userTasks.removeAll { $0.id == taskId }
                                    deteleAction()
                                })
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
            }
        }
        .listStyle(.plain)
        .background(Color.customWhiteBackground)
        .animation(.default, value: userTasks)
        .padding(.top, -8)
    }
}

struct TaskList_Previews: PreviewProvider {
    @State static var userTasks: [TaskResponseData] = []
    @State static var filterTask: CompletedType = .completed
    @State static var showTaskCompletion = false
    @State static var isTaskCompleted = false
    @State static var taskTitle = ""
    @State static var taskId = ""
    @State static var dueDate = ""
    @State static var description = ""
    @State static var assigned_to = ""
    @State static var projectId = ""
    @State static var members: [Member]? = []
    
    @State static var membersUrls: [String] = []
    
    static var previews: some View {
        TaskList(userTasks: $userTasks,
                 filterCompletedTasks: $filterTask,
                 showTask: $showTaskCompletion,
                 isTaskCompleted: $isTaskCompleted,
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
