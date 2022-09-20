import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.RobotoThinItalic)
            
            AboutUser(userName: "Artom Prischchepov",
                      userEmail: "artomprichepov@gmail.com",
                      userAvatar: "superhero",
                      createdTask: "12",
                      completedTasks: "3") {
                
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
