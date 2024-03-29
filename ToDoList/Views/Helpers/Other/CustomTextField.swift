import SwiftUI

struct CustomTextField: View {
    @State var text: LocalizedStringKey
    @State var placeholder: LocalizedStringKey
    @Binding var variable: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.RobotoRegular)
            
            HStack {
                TextField(text: $variable) {
                    Text(placeholder)
                        .font(Font(Roboto.regular(size: 16)))
                        .foregroundColor(.customGray)
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                
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
