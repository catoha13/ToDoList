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
                         showTask: $viewModel.showTaskCompletionView,
                         taskTitle: $viewModel.title,
                         taskId: $viewModel.taskId,
                         taskDueDate: $viewModel.getDate,
                         taskDescription: $viewModel.description,
                         taskAssigned_to: $viewModel.assigneeId,
                         taskProjectId: $viewModel.selectedProjectId,
                         members: $viewModel.members,
                         membersUrl: $viewModel.membersUrls,
                         deteleAction: {
                    viewModel.deleteTask()
                })
               
            }
            .animation(.default, value: viewModel.selectedIndex)
            
            if viewModel.showTaskCompletionView {
                CompleteTask(isPresented: $viewModel.showTaskCompletionView,
                             title: $viewModel.title,
                             members: $viewModel.members,
                             membersAvatars: $viewModel.membersAvatars,
                             membersId: $viewModel.membersId,
                             dueDate: $viewModel.getDate,
                             description: $viewModel.description,
                             mergedArray: $viewModel.mergedUsersAndAvatars,
                             updateAction: {
                    viewModel.updateTask()
                }, addMemberAction: {
                    viewModel.loadSearch()
                }, deleteAction: {
                    viewModel.deleteTask()
                })
                .onAppear {
                    viewModel.loadAvatars()
                }
                .onDisappear {
                    viewModel.membersAvatars = []
                    viewModel.membersUrls = []
                }
            }
        }
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
