import SwiftUI

struct CheckList: View {
    @ObservedObject var data = CheckListData()
    
    var body: some View {
        ScrollView {
            ForEach(data.checkListData, id: \.self) { item in
                CheckView(isChecked: item.isChecked, title: item.title)
                    .padding(.vertical, 10)
            }
            HStack {
                //MARK: Add Button
                Button {
                    data.checkListData.append(CheckListItem(id: UUID(), isChecked: false, title: ""))
                } label: {
                    Text("+ Add new item")
                        .font(Font(Roboto.thinItalic(size: 16)))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                
                //MARK: Delete Button
                Spacer()
                Button {
                    data.checkListData.removeLast()
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 16, height: 18)
                        .foregroundColor(.red)
                        .offset(y: -6)
                }
                .padding()
            }
        }
        .frame(height: 192)
        .padding()
    }
}

struct CheckList_Previews: PreviewProvider {
    static var previews: some View {
        CheckList()
    }
}
class CheckListData: ObservableObject {
    @Published var checkListData = [
        CheckListItem(title: "")
    ]
}

struct CheckListItem: Identifiable, Hashable {
    var id = UUID()
    var isChecked: Bool = false
    var title: String
}

struct CheckView: View {
    @State var isChecked: Bool = false
    @State var title: String
    func toggle() {
        isChecked = !isChecked
    }
    
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(.secondary)
                    .background(Color.customBar)
            }
            TextField(text: $title, label: {
                Text("List item")
            })
            
            
        }
    }
}
