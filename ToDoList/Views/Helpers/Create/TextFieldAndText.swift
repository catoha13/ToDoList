import SwiftUI

struct TextFieldAndText: View {
    @Binding var text: String
    @State var description: LocalizedStringKey
    var body: some View {
        HStack {
            Text("For")
                .font(Font(Roboto.thinItalic(size: 18)))
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
    @State static var descriprtion: LocalizedStringKey = "Assignee"
    static var previews: some View {
        TextFieldAndText(text: $text, description: descriprtion)
    }
}
