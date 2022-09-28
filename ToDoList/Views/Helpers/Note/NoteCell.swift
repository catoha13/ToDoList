import SwiftUI

struct NoteCell: View {
    @State var color: String = Color.customPink.description
    @State var text: String = "Some action to do at 10:00 AM with my friends"
    @State var isCompleted: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color(hex: color))
                .frame(width: 121, height: 3)
                .offset(y: -20)
            
            HStack {
                Text(text)
                    .font(.RobotoThinItalicSmall)
                    .strikethrough(isCompleted)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.top, -10)
                   
                Spacer()
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .frame(width: 343)
    }
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell()
    }
}
