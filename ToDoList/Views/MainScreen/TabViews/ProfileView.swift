import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var animated = false
    var body: some View {
        ZStack {
            VStack {
                TopHeader(text: "Profile")
                
                ScrollView(showsIndicators: false) {
                    AboutUser(userName: $viewModel.username,
                              userEmail: $viewModel.email,
                              userAvatar: $viewModel.avatarImage,
                              createdTask: $viewModel.createdTask,
                              completedTasks: $viewModel.completedTask) {
                        viewModel.showSetting.toggle()
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
                .padding(.top, -40)
                .background(Color.customWhiteBackground)
                .alert(isPresented: $viewModel.isOffline) {
                    Alert(title: Text("Something went wrong"), message: Text(viewModel.alertMessage), dismissButton: Alert.Button.cancel(Text("Ok")))
                }
            }
                if viewModel.showSetting && viewModel.isOffline == false {
                    ProfileSettings(isPresented: $viewModel.showSetting) {
                        viewModel.showImagePicker.toggle()
                    } signOutAction: {
                        viewModel.signOut.send()
                    }
                    
                
            }
        }
        .fullScreenCover(isPresented: $viewModel.isSignedOut) {
            SignUpView(isPresented: $viewModel.isSignedOut)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(isShown: $viewModel.showImagePicker,
                        image: $viewModel.avatarImage,
                        url: $viewModel.avatarUrl)
            .onDisappear {
                viewModel.uploadAvatar.send()
            }
        }
        .opacity(animated ? 1 : 0)
        .onAppear {
            withAnimation(.default) {
                animated.toggle()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
