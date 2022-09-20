import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    var token = Token()
    var user = User()
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.RobotoThinItalic)
            
            AboutUser(userName: $viewModel.username,
                      userEmail: $viewModel.email,
                      userAvatar: viewModel.avatarUrl,
                      createdTask: $viewModel.createdTask,
                      completedTasks: $viewModel.completedTask) {
                
            }
            StatisticCollection(tasksCount: 2,
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
                StatisticCircle(persantage: "40%",
                                text: "Events",
                                color: .customCoral, progress: 0.40)
                StatisticCircle(persantage: "80%",
                                text: "To do",
                                color: .customBlue,
                                progress: 0.80)
                StatisticCircle(persantage: "10%",
                                text: "Quick notes",
                                color: .customPurple,
                                progress: 0.10)
            }            
        }
        .background(Color.customWhiteBackground)
        .onAppear {
            viewModel.fetchUser()
            viewModel.fetchStatistics()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
