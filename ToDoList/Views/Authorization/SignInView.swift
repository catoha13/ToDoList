import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = SignInViewModel()
    
    //MARK: Custom back button
    var backButton: some View { Button(action: {
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
            HeaderAndDescription(text: "Welcome back",
                                 description: "Sign in to continue")
            .padding(.top, 24)
            
            CustomTextField(text: "Email",
                            placeholder: "Enter email",
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
            
            Button(action: {
                viewModel.signIn.send()
            }, label: {
                Text("Sign In")
            })
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 90)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                CustomTabBarView(viewRouter: ViewRouter(),
                                 isPresented: $viewModel.isPresented)
            }
            
            CustomButton(text: "Sign Up", action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            .padding(.vertical, 20)
            
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

