import SwiftUI

struct ForgotPasswordView: View {
    @State var email = ""
    
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
        
        VStack {
            HeaderAndDescription(text: "Forgot Password",
                                 description: "Please enter your email below to recevie your password reset instructions")
            .padding(.top, 24)
            
            CustomTextField(text: "Email",
                            placeholder: "Enter email",
                            variable: $email)
            .keyboardType(.emailAddress)
            
            NavigationLink("Send Request") {
                ResetPasswordView()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            
            
            
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        ForgotPasswordView()
    }
}
