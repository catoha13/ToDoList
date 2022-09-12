import SwiftUI

struct Tasks: Identifiable {
    var id = UUID()
    var task: String
    var time: String
    var color: Color
}
struct TasksDate: Identifiable {
    var id = UUID()
    var date: String
}
//------------

struct TaskEditableList: View {
    
    @State var editMode = false
    
    @State var taskDate = [
        Text("Today, Aug 4/2018"),
        Text("Tomorrow, Aug 5/2018")
    ]
    
    @State var tasks = [
        Tasks(task: "Fishing", time: "9:00 AM", color: .customCoral),
        Tasks(task: "Dinner", time: "11:00 AM", color: .blue),
        
    ]
    @State var tomorrowTasks = [
        Tasks(task: "Meeting", time: "4:00 PMM", color: .customCoral),
        Tasks(task: "Rest", time: "9:00 PM", color: .customCoral)
    ]
    
    var body: some View {
        List {
            Section {
                ForEach($tasks, content: { item in
                    Task(task: item.task,
                         time: item.time,
                         color: item.color,
                         deleteAction: {})
                })
                .listRowSeparator(.hidden)
            } header: {
                taskDate.first
                    .font(.RobotoThinItalicTaskHeader)
            }
            
            Section(content: {
                ForEach($tomorrowTasks, content: { item in
                    Task(task: item.task,
                         time: item.time,
                         color: item.color) {
//                        let indexSet = IndexSet(arrayLiteral: <#T##IndexSet.ArrayLiteralElement...##IndexSet.ArrayLiteralElement#>)
                        
                    }
                })
                .onDelete(perform: delete)
                .listRowSeparator(.hidden)
            }, header: {
                taskDate.last
                    .font(.RobotoThinItalicTaskHeader)
            })
        }
        .environment(\.editMode, .constant(self.editMode ? EditMode.active : EditMode.inactive))
    }
    func delete(at offsets: IndexSet) {
           tasks.remove(atOffsets: offsets)
       }
}



struct TaskList_Previews: PreviewProvider {

    static var previews: some View {
        TaskEditableList()
    }
}




