import SwiftUI

struct ChecklistCell: View {
    @State var title = "Some shit"
    @State var content = [ChecklistItemsModel]()
    @State var color = "#5ABB56"
    @State var action: () -> ()
    @State private var gridLayout = [GridItem(.flexible(maximum: 20)),
                                     GridItem(.flexible())]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Rectangle()
                .frame(width: 121, height: 3)
                .foregroundColor(Color(hex: color))
                .offset(y: -20)
            Text(title)
                .font(.RobotoThinItalicSmall)
                .padding(.top, -10)
            
            ForEach(content, id: \.self) { item in
                HStack {
                    Button {
                        self.action()
                    } label: {
                        Image(systemName: item.isCompleted ? "checkmark.square" : "square")
                            .foregroundColor(.secondary)
                            .background(Color.customBar)
                    }
                    Text(item.content)
                        .strikethrough(item.isCompleted ? true : false)
                        .foregroundColor(item.isCompleted ? Color.secondary : Color.black)
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.all, 20)
        .background(.white)
        .frame(width: 343)
    }
}

struct ChecklistCell_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistCell(action: {})
    }
}
