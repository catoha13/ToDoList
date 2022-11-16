import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = SignInViewModel()
    
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
            HeaderAndDescription(text: "Welcome back",
                                 description: "Sign in to continue")
            
            CustomTextField(text: "Email",
                            placeholder: "Enter your email",
                            variable: $viewModel.email)
            .keyboardType(.emailAddress)
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
            
            TextWithErrorDecsription(text: $viewModel.errorMessage)
            
            Button("Sing In") {
                viewModel.signIn.send()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                CustomTabBarView(viewRouter: ViewRouter(),
                                 isPresented: $viewModel.isPresented)
            }
            
            CustomButton(text: "Sign Up", action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            .padding(.vertical, 30)
            .padding(.bottom, 36)
            
            Spacer()
            
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

struct SignInView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SignInView()
    }
}

