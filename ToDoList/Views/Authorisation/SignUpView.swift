import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Binding var isPresented: Bool
    @State private var showImagePicker: Bool = false
    @State private var isAnimated = false
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                HeaderAndDescription(text: "Welcome",
                                     description: "Sign up to continue")
                .padding(.top, 66)
                .offset(y: isAnimated ? 0 : 200)
                .opacity(isAnimated ? 1 : 0)
                
                ZStack {
                    Image(uiImage: (viewModel.avatar ?? UIImage(named: "background"))!)
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
                    }
                }
                .offset(y: isAnimated ? 0 : 160)
                .opacity(isAnimated ? 1 : 0)
                
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
                .offset(y: isAnimated ? 0 : 100)
                .opacity(isAnimated ? 1 : 0)
                
                TextWithErrorDecsription(text: $viewModel.errorMessage)
                
                CustomCoralFilledButton(text: "Sign Up", action: {
                    viewModel.signUp.send()
                })
                .opacity(viewModel.isCredentialsValid ? 1 : 0.75)
                .padding(.top, 10)
                .offset(y: isPresented ? 0 : 70)
                .opacity(isPresented ? 1 : 0)
                .fullScreenCover(isPresented: $viewModel.isPresented) {
                    CustomTabBarView(viewRouter: ViewRouter(), isPresented: $isPresented)
                }
                
                NavigationLink("Sign In") {
                    SignInView()
                }
                .font(.RobotoMediumItalic)
                .foregroundColor(.customCoral)
                .padding(.top, 40)
                .offset(y: isAnimated ? 0 : 40)
                .opacity(isAnimated ? 1 : 0)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .navigationBarHidden(true)
            .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0), value: isAnimated)
            .onAppear{
                isAnimated.toggle()
            }
            .onDisappear {
                isAnimated.toggle()
            }
        }
       
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SignUpView(isPresented: $isPresented)
    }
}



