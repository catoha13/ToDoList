import SwiftUI

struct Dots: View {
    @Binding var selectedDot: Int
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundColor(selectedDot == 0 ? .black : .secondary)
                Circle()
                    .foregroundColor(selectedDot == 1 ? .black : .secondary)
                Circle()
                    .foregroundColor(selectedDot == 2 ? .black : .secondary)
                    
            }
            .animation(.default, value: selectedDot)
            .foregroundColor(.secondary)
            .offset(y: 120)
            .frame(width: 40, height: 40, alignment: .center)
        }
    }
}

struct Dots_Previews: PreviewProvider {
    @State static var selectedDot = 0
    static var previews: some View {
        Dots(selectedDot: $selectedDot)
    }
}
