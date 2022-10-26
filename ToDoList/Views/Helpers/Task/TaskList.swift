import SwiftUI
import Foundation

struct TaskList: View {
    @Binding var userTasks: [TaskResponseData]
    @Binding var taskTitle: String
    @Binding var taskId: String
    @Binding var showTask: Bool
    
    @State var deteleAction: () -> ()
    
    @State private var showAlert = false
    
    var body: some View {
        List {
            ForEach(userTasks, id: \.self) { task in
                TaskCell(title: task.title,
                         time: task.dueDate,
                         isDone: task.isCompleted,
                         editAction: {
                    withAnimation(.default) {
                        taskId = task.id
                        taskTitle = task.title
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
        .animation(.default, value: userTasks)
        .background(Color.customWhiteBackground.ignoresSafeArea())
        .scrollContentBackground(.hidden)
        .padding(.top, -8)
    }
    private func delete(at offsets: IndexSet) {
        userTasks.remove(atOffsets: offsets)
    }
    private func formatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = ", MMM d/yyyy"
        return formatter.string(from: date)
    }
}

struct TaskList_Previews: PreviewProvider {
    @State static var userTasks: [TaskResponseData] = []
    @State static var showTaskCompletion = false
    @State static var taskTitle = ""
    @State static var taskId = ""
    static var previews: some View {
        TaskList(userTasks: $userTasks,
                 taskTitle: $taskTitle,
                 taskId: $taskId,
                 showTask: $showTaskCompletion, deteleAction: {})
    }
}
