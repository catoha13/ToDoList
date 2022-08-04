import SwiftUI

struct ColorButton: View {
    @Binding var color: Color
    @State var isSelected: Bool?
    @State var action: () -> Void
    
    var body: some View {
        Button {
            action()
            isSelected?.toggle()
        } label: {
            RoundedRectangle(cornerRadius: Constants.radiusFive)
                .frame(width: 48, height: 48)
                .foregroundColor(color)
                .overlay(isSelected ?? false ? Image(systemName: "checkmark").foregroundColor(.white) : nil)
        }
        
    }
}

struct ColorButton_Previews: PreviewProvider {
    @State static var color: Color = .customPink
    @State static var isSelected = false
    
    static var previews: some View {
        ColorButton(color: $color, isSelected: isSelected, action: {})
    }
}
