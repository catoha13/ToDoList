import SwiftUI

struct SuccessfulView: View {
    @StateObject private var notificationManager = LocalNotificationManager()

    @State private var isPresented = false
    @State private var isAnimated = false
    
    var body: some View {
        VStack {
            Image("confirmed")
                .padding(.bottom, 10)
            
            VStack {
                Text("Successful!")
                    .font(.custom("Roboto-ThinItalic", size: 32))
                    .foregroundColor(.customBlack)
                    .padding(.bottom, 10)
                    .offset(y: isAnimated ? 0 : 200)
                    .opacity(isAnimated ? 1 : 0)
                
                Text("You have successfully change password. Please use your new passwords when logging in.")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.customBlack)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .offset(y: isAnimated ? 0 : 120)
                    .opacity(isAnimated ? 1 : 0)
            }
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                    isPresented.toggle()
                }
                notificationManager.sendNotification(title: "Hurray!",
                                                     subtitle: "Don't forget your password again",
                                                     body: "If you see this text, launching the local notification worked!", launchIn: 5)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isPresented) {
            SignUpView(isPresented: $isPresented)
        }
        .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0), value: isAnimated)
        .onAppear{
            isAnimated.toggle()
        }
        .onDisappear {
            isAnimated.toggle()
        }
    }
}

struct SuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulView()
    }
}
