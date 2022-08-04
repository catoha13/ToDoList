import SwiftUI

struct Header: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var text: String
    @Binding var isPresented: Bool
    var body: some View {
        HStack {
            BackButton(isPresented: $isPresented)
            .padding()
            Spacer()
            Text(text)
                .font(Font(Roboto.thinItalic(size: 20)))
                .foregroundColor(.white)
                .padding(.leading, -70)
            Spacer()
        }
        .frame(height: 161)
        .background(Color.customCoral)
    }
}

struct Header_Previews: PreviewProvider {
    @State static var text = "New Task"
    @State static var isPresented = false
    static var previews: some View {
        Header(text: text, isPresented: $isPresented)
    }
}
