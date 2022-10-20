import SwiftUI

struct TextFieldAndImage: View {
    @Binding var image: UIImage?
    @Binding var text: String
    @State var description: String
    
    var body: some View {
        HStack {
            Text("For")
                .font(Font(Roboto.thinItalic(size: 18)))
            ZStack {
                RoundedRectangle(cornerRadius: Constants.raidiusFifty)
                    .foregroundColor(.customBar)
                    .frame(height: 48)
                    .frame(maxWidth: image != nil ? 150 : 120)
                
                TextField(text: $text) {
                    Text(description)
                }
                .frame(maxWidth: 90)
                .multilineTextAlignment(.leading)
                .padding(.leading, image != nil ? 30 : 24)
                
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .offset(x: -56)
                    
                }
            }
            .animation(.default, value: image == nil)
        }
    }
}

struct TextFieldAndImage_Previews: PreviewProvider {
    @State static var image = UIImage(named: "background")
    @State static var text = ""
    @State static var description = ""
    
    static var previews: some View {
        TextFieldAndImage(image: $image, text: $text, description: description)
    }
}
