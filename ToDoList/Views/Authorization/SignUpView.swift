import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Binding var isPresented: Bool
    @State private var showImagePicker : Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                HeaderAndDescription(text: "Welcome",
                                     description: "Sign up to continue")
                .padding(.top, 66)
                
                ZStack {
                    viewModel.avatar?
                        .resizable()
                        .frame(width: 107, height: 104)
                        .background(.secondary)
                        .clipShape(Circle())
                        .foregroundColor(.customGray)
                        .overlay(Circle().stroke(lineWidth: 1).fill(Color.customCoral))
                    
                    CustomAvatarButton() {
                        showImagePicker.toggle()
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(isShown: $showImagePicker,
                                    image: $viewModel.avatar,
                                    url: $viewModel.url)
                        .onDisappear {
                            viewModel.uploadAvatar()
                        }
                    }
                }
                
                Group {
                    CustomTextField(text: "Email",
                                    placeholder: "Enter email",
                                    variable: $viewModel.email)
                    .keyboardType(.emailAddress)
                    
                    CustomTextField(text: "Username",
                                    placeholder: "Enter username",
                                    variable: $viewModel.username)
                    
                    CustomSecureTextField(text: "Password",
                                          placeholder: "Enter your password",
                                          variable: $viewModel.password)
                }
                .padding(.vertical, 2)
                
                TextWithErrorDecsription(text: $viewModel.errorMessage)
                
                CustomCoralFilledButton(text: "Sign Up", action: {
                    viewModel.signUp()
                })
                .padding(.top, 10)
                .fullScreenCover(isPresented: $viewModel.isPresented) {
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



