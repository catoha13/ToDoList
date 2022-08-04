import SwiftUI

struct ForgotPasswordView: View {
    var username = ""
    
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
            HeaderAndDescription(text: "Forgot Password",
                                 description: "Please enter your email below to recevie your password reset instructions")
            
            CustomTextField(text: "Username",
                            placeholder: "Enter username",
                            variable: username)
            
            NavigationLink("Send Request") {
                ResetPasswordView()
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

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        ForgotPasswordView()
    }
}
