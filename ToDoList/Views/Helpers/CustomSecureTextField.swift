import SwiftUI

struct CustomSecureTextField: View {
    @State var text: String
    @State var placeholder: String
    @Binding var variable: String
    @State private var showPassword = false
    
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
                .textInputAutocapitalization(.never)
                .overlay {
                    if showPassword && !variable.isEmpty {
                        Group {
                            RoundedRectangle(cornerRadius: 3).frame(width: 270).foregroundColor(.white)
                            HStack {
                                Text(variable)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                    }
                }
                
                if !variable.isEmpty {
                    withAnimation {
                        HStack {
                            Button {
                                variable = ""
                                showPassword = false
                            } label: {
                                Image(systemName: "plus.circle")
                                    .rotationEffect(.degrees(45))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.all, 3.8)
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(.secondary)
                            }
                        }
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
        CustomSecureTextField(text: text, placeholder: placeholder, variable: $variable)
    }
}
