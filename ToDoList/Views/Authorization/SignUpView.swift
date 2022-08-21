import SwiftUI

struct SignUpView: View {
    @State var username: String = ""
    @State var password: String = ""
    @Binding var isPresented: Bool
    @State var isMainPresented = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                HeaderAndDescription(text: "Welcome",
                                     description: "Sign up to continue")
                .padding(.top, 96)
                
                CircleImageView(image: "superhero", width: 107, height: 104)
                    .padding(.bottom, 26)
                
                CustomTextField(text: "Username",
                                placeholder: "Enter username",
                                variable: $username)
                .padding(.bottom, 20)
                
                CustomSecureTextField(text: "Password",
                                      placeholder: "Enter your password",
                                      variable: $password)
                
                CustomCoralFilledButton(text: "Sign Up", action: {
                    
                })
                .padding(.top, 72)
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



