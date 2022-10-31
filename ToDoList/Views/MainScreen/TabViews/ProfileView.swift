import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.RobotoThinItalicHeader)
                .padding(.top, -30)
            
            AboutUser(userName: $viewModel.username,
                      userEmail: $viewModel.email,
                      userAvatar: $viewModel.avatarImage,
                      createdTask: $viewModel.createdTask,
                      completedTasks: $viewModel.completedTask) {
                
            }
            StatisticCollection(tasksCount: $viewModel.createdTask,
                                toDoCount: 13,
                                eventsCount: 9)
                .padding()
            
            HStack {
                Text("Statistic")
                    .font(.RobotoThinItalicSmall)
                    .padding(.top)
                    .padding(.leading, 40)
                Spacer()
            }
            
            HStack {
                StatisticCircle(percentage: $viewModel.eventsPercentage,
                                text: "Events",
                                color: .customCoral,
                                progress: $viewModel.eventsProgress)
                
                StatisticCircle(percentage: $viewModel.toDotsPercentage,
                                text: "To do",
                                color: .customBlue,
                                progress: $viewModel.toDoProgress)
                
                StatisticCircle(percentage: $viewModel.quickNotesPercentage,
                                text: "Quick notes",
                                color: .customPurple,
                                progress: $viewModel.quickNoteProgress)
            }
        }
        .background(Color.customWhiteBackground)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
