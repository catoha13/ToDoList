import SwiftUI
import UIKit

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
                    viewModel.deleteTask.send()
                })
                
            }
            .animation(.default, value: viewModel.selectedIndex)
            .alert(isPresented: $viewModel.isOffline) {
                Alert(title: Text("Something went wrong"), message: Text(viewModel.alertMessage), dismissButton: Alert.Button.cancel(Text("Ok")))
            }
            
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
                    viewModel.updateTask.send()
                },
                             addMembersAction: {
                    viewModel.updateTask.send()
                }, deleteTaskAction: {
                    viewModel.deleteTask.send()
                },
                             createCommentAction: {
                    viewModel.createComment.send()
                    viewModel.fetchComments.send()
                },
                             deleteCommentAction: {
                    viewModel.deleteComment.send()
                })
                .onAppear {
                    viewModel.loadMembers.send()
                    viewModel.loadAddMembers.send()
                    viewModel.fetchComments.send()
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
