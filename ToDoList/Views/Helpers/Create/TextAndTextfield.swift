import SwiftUI

struct TextAndTextfield: View {
    @Binding var text: String
    @State var description: String
    var body: some View {
        HStack {
            Text("For")
                .font(Font(Roboto.thinItalic(size: 14)))
            TextField(text: $text) {
                Text(description)
            }
            .frame(width: 90, height: 48)
            .multilineTextAlignment(.center)
            .background(.bar)
            .cornerRadius(Constants.raidiusFifty)
        }
    }
}
struct TextAndTextfield_Previews: PreviewProvider {
    @State static var text = ""
    @State static var descriprtion = "Assignee"
    static var previews: some View {
        TextAndTextfield(text: $text, description: descriprtion)
    }
}
