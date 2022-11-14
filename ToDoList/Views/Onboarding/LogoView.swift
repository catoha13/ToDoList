import SwiftUI
import Combine

struct LogoView: View {
    @AppStorage("firstAccess") var firstAccess: Bool = true
    @State private var showOnboarding = false
    @State private var showSignUp = false
    @State private var selectedTab = 0
    @State private var isSignedIn = false
    
    private var token = Token()
    
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
                if firstAccess {
                    showOnboarding.toggle()
                } else {
                    
                    showSignUp.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView(isPresented: $showSignUp)
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            ZStack {
                Dots(selectedDot: $selectedTab)
                TabView(selection: $selectedTab) {
                    OnboardingView(isPresented: showOnboarding,
                                   image: "events",
                                   text: "Welcome to todo list",
                                   description: "Whats going to happen tomorrow?",
                                   backgroundFirst: "pathFirst",
                                   backgroundSecond: "pathFirstBack",
                                   buttonAction: {
                        selectedTab += 1
                    })
                    .tag(0)
                    
                    OnboardingView(isPresented: showOnboarding,
                                   image: "superhero",
                                   text: "Work happens",
                                   description: "Get notified when work happens.",
                                   backgroundFirst: "pathSecond",
                                   backgroundSecond: "pathSecondBack",
                                   buttonAction: {
                        selectedTab += 1
                    })
                    .tag(1)
                    
                    OnboardingView(isPresented: showOnboarding,
                                   image: "analysis",
                                   text: "Tasks and assign",
                                   description: "Task and assign them to colleagues.",
                                   backgroundFirst: "pathThird",
                                   backgroundSecond: "pathThirdBack",
                                   buttonAction: {
                        showSignUp.toggle()
                        firstAccess = false
                    })
                    .tag(2)
                    .fullScreenCover(isPresented: $showSignUp) {
                        SignUpView(isPresented: $showSignUp)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(edges: .bottom)
            }
        })
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
