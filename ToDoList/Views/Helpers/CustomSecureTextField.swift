import SwiftUI

struct CustomSecureTextField: View {
    @State var text: String
    @State var placeholder: String
    @State var variable: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.RobotoRegular)
            
            HStack {
                SecureField(text: $variable) {
                    Text(placeholder)
                        .font(.custom("Roboto-Regular", size: 16)) // add to extension?
                        .foregroundColor(.customGray)
                }
                if !variable.isEmpty {
                    withAnimation {
                        Button {
                            variable = ""
                        } label: {
                            Image(systemName: "plus.circle")
                                .rotationEffect(.degrees(45))
                                .foregroundColor(.secondary)
                        }
                        .padding(.all, 1)
                    }
                }
            }
            Divider()
        }
    }
}

struct CustomSecureTextField_Previews: PreviewProvider {
    @State static var text = ""
    @State static var placeholder = "Enter password"
    @State static var variable = ""
    static var previews: some View {
        CustomSecureTextField(text: text, placeholder: placeholder, variable: variable)
    }
}
