import SwiftUI

// странно располоожена кнопка при вызове клавиатуры

struct ResetPasswordView: View {
    var resetNumber = ""
    var newPassword = ""
    var confirmPassword = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: Custom back button
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left") // set image here
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 25.2, height: 17.71)
                    .padding()
            }
        }
    
    var body: some View {
        
        VStack {
            HeaderAndDescription(text: "Reset Password",
                                 description: "Reset code was sent to your email. Please enter the code and create new password")
            
            CustomTextField(text: "Reset code",
                            placeholder: "Enter your number",
                            variable: resetNumber)
            
            CustomTextField(text: "New password",
                            placeholder: "Enter new password",
                            variable: newPassword)
            
            CustomTextField(text: "Confirm password",
                            placeholder: "Confirm",
                            variable: confirmPassword)
            
            NavigationLink("Change password") {
                SuccessfulView()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
