import SwiftUI

struct CustomTextField: View {
    @State var text: String
    @State var placeholder: String
    @State var variable: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.RobotoRegular)
            
            HStack {
                TextField(text: $variable) {
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
