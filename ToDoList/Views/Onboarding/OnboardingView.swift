import SwiftUI

struct OnboardingView: View {
    @State var isPresented: Bool
    
    var image: String
    var text: String
    var description: String
    var backgroundFirst: String
    var backgroundSecond: String
    var buttonAction: () -> Void
    
    var body: some View {
        VStack {
            Image(image)
                .padding(.top, 46)
                .frame(width: 400, height: 300)
            
            Text(text)
                .font(.RobotoThinItalic)
                .foregroundColor(.customBlack)
                .padding(.top, 50)
            
            Text(description)
                .font(.RobotoMedium)
                .font(.system(.title3))
                .foregroundColor(.customBlack)
                .padding(.top, 11)
            
            ZStack {
                Image(backgroundFirst)
                    .resizable()
                
                Image(backgroundSecond)
                    .resizable()
                
                Button {
                    self.buttonAction()
                } label: {
                    Text("Get Started")
                }
                .buttonStyle(CustomButtonStyleOnboarding())
                
            }
            .ignoresSafeArea()
            .frame(maxHeight: 362, alignment: .bottom)
            .padding(.top, 90)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var image = "events"
    @State static var text = "Welcome to todo list"
    @State static var description = "Whats going to happen tomorrow?"
    @State static var backgroundFirst = "pathFitst"
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
