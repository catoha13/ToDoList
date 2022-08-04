import SwiftUI

struct ChooseColor: View {
    @Binding var selectedColor: Color
    @State var selectedButton: Bool? = nil
    @State private var selectButton = [false, false, false ,false, false]
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
                ForEach(0..<colorArray.count, id: \.self) { element in
                    ColorButton(color: $colorArray[element],
                                isSelected: selectButton[element]) {
                        selectedColor = colorArray[element]
                    }
                }
            }
        }
        .frame(width: 284, height: 87)
    }
}

struct ChooseColor_Previews: PreviewProvider {
    @State static var selectedColor: Color = .customBiege
    static var previews: some View {
        ChooseColor(selectedColor: $selectedColor)
    }
}
