import SwiftUI

struct ColorButton: View {
    @Binding var selectedColor: Color
    @State var color: Color
    @State private var isSelected = false
    
    var body: some View {
        Button {
            isSelected.toggle()
            selectedColor = color
        } label: {
            RoundedRectangle(cornerRadius: Constants.radiusFive)
                .frame(width: 48, height: 48)
                .foregroundColor(color)
                .overlay(selectedColor == color ? Image(systemName: "checkmark").foregroundColor(.white) : nil)
        }
    }
}

struct ColorButton_Previews: PreviewProvider {
    @State static var color: Color = .customPink
    @State static var selectedColor: Color = .customBlue
    
    static var previews: some View {
        ColorButton(selectedColor: $selectedColor, color: color)
    }
}
