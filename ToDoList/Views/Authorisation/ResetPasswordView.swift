import SwiftUI

struct ResetPasswordView: View {
    @State var resetNumber = ""
    @State var newPassword = ""
    @State var confirmPassword = ""
    @State private var isAnimated = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: Custom back button
    var backButton : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        Image(systemName: "arrow.left")
            .resizable()
            .foregroundColor(.black)
            .frame(width: 25.2, height: 17.71)
            .padding()
    }
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HeaderAndDescription(text: "Reset Password",
                                 description: "Reset code was sent to your email. Please enter the code and create new password")
            .padding(.top, -24)
            .offset(x: isAnimated ? 0 : 100)
            .opacity(isAnimated ? 1 : 0)
            
            CustomTextField(text: "Reset code",
                            placeholder: "Enter the number",
                            variable: $resetNumber)
            .offset(x: isAnimated ? 0 : 80)
            .opacity(isAnimated ? 1 : 0)
            
            CustomSecureTextField(text: "New password",
                                  placeholder: "Enter new password",
                                  variable: $newPassword)
            .offset(x: isAnimated ? 0 : 60)
            .opacity(isAnimated ? 1 : 0)
            
            CustomSecureTextField(text: "Confirm password",
                                  placeholder: "Confirm",
                                  variable: $confirmPassword)
            .offset(x: isAnimated ? 0 : 40)
            .opacity(isAnimated ? 1 : 0)
            
            NavigationLink("Change password") {
                SuccessfulView()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0), value: isAnimated)
        .onAppear{
            isAnimated.toggle()
        }
        .onDisappear {
            isAnimated.toggle()
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
