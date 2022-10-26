import SwiftUI

struct LogoView: View {
    @State private var isPresented = false
    @State private var selectedTab = 0
    @State private var isSingUpPresented = false
    
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
                isPresented.toggle()
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            ZStack {
                Dots(selectedDot: $selectedTab)
                TabView(selection: $selectedTab) {
                    OnboardingView(isPresented: isPresented,
                                   image: "events",
                                   text: "Welcome to todo list",
                                   description: "Whats going to happen tomorrow?",
                                   backgroundFirst: "pathFirst",
                                   backgroundSecond: "pathFirstBack",
                                   buttonAction: self.nextScreen)
                    .tag(0)
                    
                    OnboardingView(isPresented: isPresented,
                                   image: "superhero",
                                   text: "Work happens",
                                   description: "Get notified when work happens.",
                                   backgroundFirst: "pathSecond",
                                   backgroundSecond: "pathSecondBack",
                                   buttonAction: self.nextScreen)
                    .tag(1)
                    
                    OnboardingView(isPresented: isPresented,
                                   image: "analysis",
                                   text: "Tasks and assign",
                                   description: "Task and assign them to colleagues.",
                                   backgroundFirst: "pathThird",
                                   backgroundSecond: "pathThirdBack",
                                   buttonAction: self.showMainScreen)
                    .tag(2)
                    .fullScreenCover(isPresented: $isSingUpPresented) {
                        SignUpView(isPresented: $isSingUpPresented)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(edges: .bottom)
            }
        })
    }
    
    func nextScreen() {
        withAnimation {
            self.selectedTab += 1
        }
    }
    
    func showMainScreen() {
        // present to main screen
        isSingUpPresented.toggle()
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
