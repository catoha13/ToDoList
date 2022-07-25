import SwiftUI

struct CustomTextField: View {
    @State var text: String
    @State var placeholder: String
    @State var variable: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.RobotoRegular)
            
            TextField(text: $variable) {
                Text(placeholder)
                    .font(.custom("Roboto-Regular", size: 16)) // add to extension?
                    .foregroundColor(.customGray)
            }
            Divider()
        }
    }
}
