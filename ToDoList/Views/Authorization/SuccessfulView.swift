import SwiftUI

struct SuccessfulView: View {
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
