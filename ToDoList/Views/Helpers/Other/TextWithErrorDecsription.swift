import SwiftUI

struct TextWithErrorDecsription: View {
    @Binding var text: String
    var body: some View {
        Text(text)
            .padding()
            .font(.footnote)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .animation(.easeIn(duration: 0.1), value: text)
    }
}

struct TextWithErrorDecsription_Previews: PreviewProvider {
    @State static var text = "Some text"
    static var previews: some View {
        TextWithErrorDecsription(text: $text)
    }
}
