import SwiftUI

struct ChecklistCell: View {
    @State var content = [ChecklistItemsModel]()
    @State var title = "Some"
    @State var color = "#5ABB56"
    @Binding var itemContent: String
    @Binding var itemId: String
    @Binding var itemIsCompleted: Bool
    @State var action = {}
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 121, height: 3)
                    .foregroundColor(Color(hex: color))
                    .offset(y: -20)
                Spacer()
            }
            HStack {
                Text(title)
                    .font(.RobotoThinItalicSmall)
                    .padding(.top, -10)
                Spacer()
            }
            
            ForEach(content, id: \.self) { item in
                HStack {
                    Button {
                        withAnimation {
                            itemContent = item.content
                            itemId = item.id ?? ""
                            itemIsCompleted = item.isCompleted
                            self.action()
                        }
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
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .frame(width: 343)
    }
}

struct ChecklistCell_Previews: PreviewProvider {
    @State static var itemId = ""
    @State static var isCompleted = false
    @State static var title = ""
    @State static var color = ""
    static var previews: some View {
        ChecklistCell(itemContent: $title, itemId: $itemId, itemIsCompleted: $isCompleted)
    }
}
