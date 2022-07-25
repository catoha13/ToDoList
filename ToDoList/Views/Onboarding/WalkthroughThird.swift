import SwiftUI

struct WalkthroughThird: View {
    @State var isPresented: Bool
    
    var body: some View {
            VStack {
                Image("events")
                    .padding(.top, 46)
                
                Text("Work happens")
                    .font(.custom("Roboto-ThinItalic", size: 24))
                    .foregroundColor(.customBlack)
                    .padding(.top, 50)
                
                Text("Get notified when work happens.")
                    .font(.custom("Roboto-Medium", size: 18))
                    .font(.system(.title3))
                    .foregroundColor(.customBlack)
                    .padding(.top, 11)
                
                DotsView(firstColor: false,
                         secondColor: false,
                         thirdColor: true)
                
                ZStack {
                    Image("pathThird")
                        .resizable()
                    
                    Image("pathThirdBack")
                        .resizable()
                    
                    NavigationLink {
                      
                    } label: {
                        Text("Get Started")
                    }
                    .buttonStyle(CustomButtonStyleOnboarding())
                }
                .ignoresSafeArea()
                .frame(maxHeight: 362, alignment: .bottom)
                .padding(.top, 90)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

struct WalkthroughThird_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        WalkthroughThird(isPresented: isPresented)
    }
}
