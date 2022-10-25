import SwiftUI
import Foundation

struct TaskEditableList: View {
    @Binding var userTasks: [TaskResponseData]
    
    @State var showTaskCompletion: Bool
    @State var showEditView = false
    
    var body: some View {
        List($userTasks, id: \.self) { task in
            
            TaskCell(title: task.title, time: task.dueDate, isDone: task.isCompleted,
                     updateAction: {
                withAnimation(.default) {
                    showTaskCompletion.toggle()
                }
            }, editAction: {
                
            },
                     deleteAction: {
                
            })
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
            .border(.black)
            .frame(width: 343, height: 70)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 2)
            
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
        TaskEditableList(userTasks: $userTasks,
                         showTaskCompletion: showTaskCompletion)
    }
}
