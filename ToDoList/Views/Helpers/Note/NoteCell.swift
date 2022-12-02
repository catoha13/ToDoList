import SwiftUI

struct NoteCell: View {
    @State var color: String = Color.customPink.description
    @State var text: String = "Some action to do at 10:00 AM with my friends"
    @State var isCompleted: Bool = false
    @State var isOffline: Bool = false
    @State var updateAction: () -> ()
    @State var longTap: () -> ()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color(hex: color))
                .frame(width: 121, height: 3)
                .offset(y: -20)
            
            HStack {
                Button {
                } label: {
                    Text(text)
                        .font(.RobotoThinItalicSmall)
                        .strikethrough(isCompleted)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .onTapGesture {
                            withAnimation {
                                updateAction()
                                isCompleted.toggle()
                            }
                        }
                        .onLongPressGesture {
                            longTap()
                        }
                }
                .disabled(isOffline)
                Spacer()
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .frame(width: 343)
        .background(.white)
        .cornerRadius(Constants.radiusThree)
        .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 3)
    }
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(updateAction: {}, longTap: {})
    }
}
