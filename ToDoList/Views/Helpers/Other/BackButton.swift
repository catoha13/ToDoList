import SwiftUI

struct BackButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25.2, height: 17.71)
            }
        }
        .padding(.leading)
    }
}

struct BackButton_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        BackButton(isPresented: $isPresented)
    }
}
