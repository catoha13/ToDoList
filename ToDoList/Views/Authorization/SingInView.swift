import SwiftUI

struct SingInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = SignInViewModel()
    
    //MARK: Custom back button
    var btnBack : some View { Button(action: {
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
            HeaderAndDescription(text: "Welcome back",
                                 description: "Sign in to continue")
            
            CustomTextField(text: "Email",
                            placeholder: "Enter your email",
                            variable: $viewModel.username)
                .padding(.bottom, 20)
            
            VStack(alignment: .trailing) {
                CustomSecureTextField(text: "Password",
                                      placeholder: "Enter your password",
                                      variable: $viewModel.password)
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("Forgot password")
                        .font(.RobotoThinItalicSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Button("Sing In") {
                viewModel.signIn()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            
            CustomButton(text: "Sign Up", action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            .padding(.vertical, 50)
            
            Spacer()
            
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct SingInView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SingInView()
    }
}

