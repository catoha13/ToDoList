import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = SignInViewModel()
    @State private var isAnimated = false
    
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
            .offset(x: isAnimated ? 0 : 100)
            .opacity(isAnimated ? 1 : 0)
            
            CustomTextField(text: "Email",
                            placeholder: "Enter email",
                            variable: $viewModel.email)
            .keyboardType(.emailAddress)
            .padding(.bottom, 20)
            .offset(x: isAnimated ? 0 : 80)
            .opacity(isAnimated ? 1 : 0)
            
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
            .offset(x: isAnimated ? 0 : 60)
            .opacity(isAnimated ? 1 : 0)
            
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
            .offset(x: isAnimated ? 0 : 60)
            .opacity(isAnimated ? 1 : 0)
            
            CustomButton(text: "Sign Up", action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            .padding(.vertical, 20)
            .offset(x: isAnimated ? 0 : 60)
            .opacity(isAnimated ? 1 : 0)
            
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

struct SignInView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SignInView()
    }
}

