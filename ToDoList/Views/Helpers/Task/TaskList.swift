import SwiftUI
import Foundation

struct TaskList: View {
    @Binding var userTasks: [TaskResponseData]
    
    @Binding var showTaskCompletion: Bool
    @State private var showEditView = false
    
    var body: some View {
        List($userTasks, id: \.self) { task in
            
            TaskCell(title: task.title, time: task.dueDate, isDone: task.isCompleted,
                     editAction: {
                withAnimation(.default) {
                    showTaskCompletion.toggle()
                }
            },
                     deleteAction: {
                
            })
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
            .frame(width: 343, height: 70)
            .cornerRadius(Constants.radiusFive)
            
        }
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
    static var previews: some View {
        TaskList(userTasks: $userTasks,
                 showTaskCompletion: $showTaskCompletion)
    }
}
