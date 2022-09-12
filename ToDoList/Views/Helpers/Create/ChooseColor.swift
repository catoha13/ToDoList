import SwiftUI

struct ChooseColor: View {
    @State var selectedColor: Color
    @State private var colorArray = [Color.customBlue,
                                     Color.customPink,
                                     Color.customGreen,
                                     Color.customDarkPurple,
                                     Color.customBiege]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose Color")
                .font(Font(Roboto.thinItalic(size: 18)))
                .padding()
            HStack {
                ForEach(colorArray, id: \.self) { element in
                    ColorButton(selectedColor: $selectedColor, color: element)
                }
            }
        }
        .frame(width: 284, height: 87)
    }
}

struct ChooseColor_Previews: PreviewProvider {
    @State static var selectedColor: Color = .customBlue
    static var previews: some View {
        ChooseColor(selectedColor: selectedColor)
    }
}
