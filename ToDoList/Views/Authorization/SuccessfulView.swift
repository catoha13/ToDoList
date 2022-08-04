import SwiftUI

struct SuccessfulView: View {
    var body: some View {
        VStack {
            Image("confirmed")
                .padding(.bottom, 10)
            
            VStack {
                Text("Successful!")
                    .font(.custom("Roboto-ThinItalic", size: 32)) // add to extension?
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
            
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
        .navigationBarBackButtonHidden(true)
    }
}

struct SuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulView()
    }
}
