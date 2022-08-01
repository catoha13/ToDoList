import SwiftUI

struct Header: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var text: String
    var body: some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25.2, height: 17.71)
                    .padding(.leading, 10)
            }
            .padding()
            Spacer()
            Text(text)
                .font(Font(Roboto.thinItalic(size: 20)))
                .foregroundColor(.white)
                .padding(.leading, -50)
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
