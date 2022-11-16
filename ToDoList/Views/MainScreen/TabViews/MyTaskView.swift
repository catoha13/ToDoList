import SwiftUI

struct MyTaskView: View {
    @StateObject var viewModel = TaskViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TaskHeader() {
                    withAnimation(.default) {
                        viewModel.showFilter.toggle()
                    }
                }
                
                SegmentedPickerExample(titles: ["Today", "Month"], selectedIndex: $viewModel.selectedIndex)
                
                if viewModel.selectedIndex == 1 {
                    CustomCalendar(selectedDate: $viewModel.selectedDate)
                }
                
                TaskList(userTasks: $viewModel.fetchTasksResponse,
                         filterCompletedTasks: $viewModel.filterCompletedTasks,
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
                             isCompleted: $viewModel.isCompleted,
                             title: $viewModel.title,
                             members: $viewModel.members,
                             membersAvatars: $viewModel.membersAvatars,
                             membersId: $viewModel.membersId,
                             dueDate: $viewModel.getDate,
                             description: $viewModel.description,
                             commentText: $viewModel.commentText,
                             comments: $viewModel.commentsResponseArray,
                             commentId: $viewModel.commentId,
                             mergedArray: $viewModel.usersAndAvatars,
                             updateAction: {
                    viewModel.isCompleted.toggle()
                    viewModel.updateTask()
                },
                             addMembersAction: {
                    viewModel.updateTask()
                }, deleteTaskAction: {
                    viewModel.deleteTask()
                },
                createCommentAction: {
                    viewModel.createComment()
                    viewModel.commentText = ""
                    viewModel.fetchComments()
                },
                deleteCommentAction: {
                    viewModel.deleteComment()
                })
                .onAppear {
                    viewModel.loadAvatars()
                    viewModel.loadUsers()
                    viewModel.fetchComments()
                }
                .onDisappear {
                    viewModel.membersAvatars = []
                    viewModel.membersUrls = []
                }
            }
            
            if viewModel.showFilter {
                TaskFilterSettings(isPresented: $viewModel.showFilter,
                                   isSelected: $viewModel.filterIndex,
                                   showIncpomlete: {
                    viewModel.filterCompletedTasks = false
                },
                                   showComplete: {
                    viewModel.filterCompletedTasks = true
                },
                                   showAll: {
                    viewModel.filterCompletedTasks = nil
                })
            }
        }
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
