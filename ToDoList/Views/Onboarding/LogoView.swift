import SwiftUI
import Combine

struct LogoView: View {
    @StateObject private var viewModel = LogoViewModel()
    
    var body: some View {
        VStack {
            Image("logo")
                .frame(width: 149, height: 149)
            
            Text("todo list")
                .font(.RobotoThinItalicLarge)
                .foregroundColor(.customBlack)
                .padding(.top, 15)
            
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                if viewModel.firstAccess == false {
                    viewModel.showOnboarding.toggle()
                } else {
                    if viewModel.isSignedIn {
                        viewModel.showMainScreen.toggle()
                    } else {
                        viewModel.showSignUp.toggle()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showOnboarding, content: {
            ZStack {
                Dots(selectedDot: $viewModel.selectedTab)
                TabView(selection: $viewModel.selectedTab) {
                    OnboardingView(isPresented: viewModel.showOnboarding,
                                   image: "events",
                                   text: "Welcome to todo list",
                                   description: "Whats going to happen tomorrow?",
                                   backgroundFirst: "pathFirst",
                                   backgroundSecond: "pathFirstBack",
                                   buttonAction: {
                        viewModel.selectedTab += 1
                    })
                    .tag(0)
                    
                    OnboardingView(isPresented: viewModel.showOnboarding,
                                   image: "superhero",
                                   text: "Work happens",
                                   description: "Get notified when work happens.",
                                   backgroundFirst: "pathSecond",
                                   backgroundSecond: "pathSecondBack",
                                   buttonAction: {
                        viewModel.selectedTab += 1
                    })
                    .tag(1)
                    
                    OnboardingView(isPresented: viewModel.showOnboarding,
                                   image: "analysis",
                                   text: "Tasks and assign",
                                   description: "Task and assign them to colleagues.",
                                   backgroundFirst: "pathThird",
                                   backgroundSecond: "pathThirdBack",
                                   buttonAction: {
                        viewModel.showSignUp.toggle()
                        viewModel.firstAccess = false
                    })
                    .tag(2)
                    .fullScreenCover(isPresented: $viewModel.showSignUp) {
                        SignUpView(isPresented: $viewModel.showSignUp)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(edges: .bottom)
            }
        })
        .fullScreenCover(isPresented: $viewModel.showSignUp) {
            SignUpView(isPresented: $viewModel.showSignUp)
        }
        .fullScreenCover(isPresented: $viewModel.showMainScreen) {
            CustomTabBarView(viewRouter: ViewRouter(),
                             isPresented: $viewModel.showMainScreen)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
