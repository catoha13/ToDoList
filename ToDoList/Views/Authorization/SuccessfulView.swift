import SwiftUI
import Foundation

struct SuccessfulView: View {
    @StateObject private var notificationManager = LocalNotificationManager()

    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Image("confirmed")
                .padding(.bottom, 10)
            
            VStack {
                Text("Successful!")
                    .font(.custom("Roboto-ThinItalic", size: 32))
                    .foregroundColor(.customBlack)
                    .padding(.bottom, 10)
                
                Text("You have successfully change password. Please use your new passwords when logging in.")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.customBlack)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
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
    }
}

struct SuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulView()
    }
}
