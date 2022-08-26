import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Binding var isPresented: Bool
    @State var isMainPresented = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                HeaderAndDescription(text: "Welcome",
                                     description: "Sign up to continue")
                .padding(.top, 96)
                
                CircleImageView(image: viewModel.avatar, width: 107, height: 104)
                    .padding(.bottom, 26)
                
                Group {
                    CustomTextField(text: "Email",
                                    placeholder: "Enter email",
                                    variable: $viewModel.email)
                    
                    CustomTextField(text: "Username",
                                    placeholder: "Enter username",
                                    variable: $viewModel.username)
                    
                    CustomSecureTextField(text: "Password",
                                          placeholder: "Enter your password",
                                          variable: $viewModel.password)
                }
                .padding(.vertical, 2)
                CustomCoralFilledButton(text: "Sign Up", action: {
                    
                })
                .padding(.top, 32)
                .fullScreenCover(isPresented: $isMainPresented) {
                    CustomTabBarView(viewRouter: ViewRouter(), isPresented: $isPresented)
                }
                
                NavigationLink("Sign In") {
                    SingInView()
                }
                .font(.RobotoMediumItalic)
                .foregroundColor(.customCoral)
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .navigationBarHidden(true)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SignUpView(isPresented: $isPresented)
    }
}



