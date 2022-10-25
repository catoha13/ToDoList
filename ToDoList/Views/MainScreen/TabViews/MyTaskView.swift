import SwiftUI

struct MyTaskView: View {
    @ObservedObject var viewModel = TaskViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TaskHeader(action: {})
                
                SegmentedPickerExample(titles: ["Today", "Month"], selectedIndex: $viewModel.selectedIndex)
                
                if viewModel.selectedIndex == 1 {
                    CustomCalendar(selectedDate: $viewModel.selectedDate)
                }
                
                TaskList(userTasks: $viewModel.fetchTasksResponse,
                                 showTaskCompletion: $viewModel.showTaskCompletionView)
               
            }
            .animation(.default, value: viewModel.selectedIndex)
            
            if viewModel.showTaskCompletionView {
                CompleteTask(isPresented: $viewModel.showTaskCompletionView)
            }
        }
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
