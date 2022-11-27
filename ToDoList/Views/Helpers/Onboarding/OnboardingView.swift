import SwiftUI

struct OnboardingView: View {
    @State var isPresented: Bool
    @State private var isAnimated = false
    
    var image: String
    var text: LocalizedStringKey
    var description: LocalizedStringKey
    var backgroundFirst: String
    var backgroundSecond: String
    var buttonAction: () -> Void
    
    var body: some View {
        VStack {
            Image(image)
                .padding(.top, 46)
                .frame(width: 400, height: 300)
                .opacity(isAnimated ? 1 : 0)
            
            Text(text)
                .font(.RobotoThinItalic)
                .foregroundColor(.customBlack)
                .padding(.top, 50)
                .offset(y: isAnimated ? 0 : 110)
            
            Text(description)
                .font(.RobotoMedium)
                .multilineTextAlignment(.center)
                .font(.system(.title3))
                .foregroundColor(.customBlack)
                .padding(.top, 11)
                .offset(y: isAnimated ? 0 : 80)
            
            ZStack {
                Image(backgroundFirst)
                    .resizable()
                
                Image(backgroundSecond)
                    .resizable()
                
                Button {
                    withAnimation {
                        self.buttonAction()
                    }
                } label: {
                    Text("Get Started")
                }
                .buttonStyle(CustomButtonStyleOnboarding())
                .offset(y: isAnimated ? 0 : 20)
                .opacity(isAnimated ? 1 : 0)
                
            }
            .ignoresSafeArea()
            .frame(maxHeight: 362, alignment: .bottom)
            .padding(.top, 90)
        }
        .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0), value: isAnimated)
        .onAppear {
            isAnimated.toggle()
        }
        .onDisappear {
            isAnimated.toggle()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var image = "events"
    @State static var text: LocalizedStringKey = "Welcome to todo list"
    @State static var description: LocalizedStringKey = "Whats going to happen tomorrow?"
    @State static var backgroundFirst = "pathFirst"
    @State static var backgroundSecond = "pathFirstBack"
    @State static var buttonAction = {}
    
    
    static var previews: some View {
        OnboardingView(isPresented: isPresented,
                       image: image,
                       text: text,
                       description: description,
                       backgroundFirst: backgroundFirst,
                       backgroundSecond: backgroundSecond,
                       buttonAction: buttonAction)
        
    }
}
