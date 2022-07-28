import SwiftUI

struct Header: View {
    @State var text: String
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(Font(Roboto.thinItalic(size: 20)))
                .foregroundColor(.white)
                .padding(.top, -24)
            Spacer()
        }
        .frame(height: 161)
        .background(Color.customCoral)
    }
}

struct Header_Previews: PreviewProvider {
    @State static var text = "New Task"
    static var previews: some View {
        Header(text: text)
    }
}
