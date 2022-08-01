import SwiftUI

struct SideView: View {
    @Binding var isPresented: Bool
    @State var firstText: String
    @State var secondText: String
    @State var thirdText: String
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            
            VStack(alignment: .leading, spacing: 20) {
                    Button {
                        
                    } label: {
                        Text(firstText)
                        Spacer()
                    }
                Button {
                    
                } label: {
                    Text(secondText)
                }
                Button {
                    
                } label: {
                    Text(thirdText)
                }
            }
            .padding(.leading)
            .font(Font(Roboto.thinItalic(size: 17)))
            .foregroundColor(.secondary)
            .frame(width: 228, height: 130)
            .background(.bar)
            .cornerRadius(Constants.radiusFive)
            .offset(x: 40, y: -240)
        }
    }
}

struct SideView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var firstText = "Add Member"
    @State static var secondText = "Edit Task"
    @State static var thirdText = "Delete Task"
    
    static var previews: some View {
        SideView(isPresented: $isPresented, firstText: firstText, secondText: secondText, thirdText: thirdText)
    }
}
