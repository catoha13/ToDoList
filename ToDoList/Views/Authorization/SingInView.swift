import SwiftUI

// не совсем понятно на какой экран вести юзера при нажатии sign in

struct SingInView: View {
    @State var username: String = ""
    @State var password: String = ""
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
            HeaderAndDescription(text: "Welcome back",
                                 description: "Sign in to continue")
            
            CustomTextField(text: "Username",
                            placeholder: "Enter username",
                            variable: username)
                .padding(.bottom, 20)
            
            VStack(alignment: .trailing) {
                CustomTextField(text: "Password",
                                placeholder: "Enter your password",
                                variable: password)
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("Forgot password")
                        .font(.RobotoThinItalicSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            NavigationLink("Sing In") {
                // some action
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            
            CustomButton(text: "Sign Up", action: {
                
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

