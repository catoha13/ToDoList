import SwiftUI

struct ForgotPasswordView: View {
    @State var email = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: Custom back button
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 25.2, height: 17.71)
                .padding()
        }
    }
    @State private var isAnimated = false
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HeaderAndDescription(text: "Forgot Password",
                                 description: "Please enter your email below to recevie your password reset instructions")
            .padding(.top, -24)
            .offset(x: isAnimated ? 0 : 140)
            .opacity(isAnimated ? 1 : 0)
            
            CustomTextField(text: "Email",
                            placeholder: "Enter email",
                            variable: $email)
            .keyboardType(.emailAddress)
            .offset(x: isAnimated ? 0 : 100)
            .opacity(isAnimated ? 1 : 0)
            
            NavigationLink("Send Request") {
                ResetPasswordView()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 80)
            .offset(x: isAnimated ? 0 : 40)
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

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        ForgotPasswordView()
    }
}
