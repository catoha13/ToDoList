import SwiftUI

struct CheckList: View {
    @Binding var checklistArray: [ChecklistItemsModel]
    @State private var isCompleted = false
    @State private var title = ""
    private var item: ChecklistItemsModel {
        ChecklistItemsModel(content: title, isCompleted: isCompleted)
    }
    
    var body: some View {
        ScrollView {
            ForEach($checklistArray, id: \.self) { item  in
                CheckView(title: item.content, isChecked: item.isCompleted )
                    .padding(.vertical, 10)
            }
            HStack {
                //MARK: Add Button
                Button {
                    checklistArray.append(item)
                } label: {
                    Text("+ Add new item")
                        .font(Font(Roboto.thinItalic(size: 16)))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                
                //MARK: Delete Button
                Spacer()
                Button {
                    if checklistArray.count == 0 {
                        return
                    } else {
                        checklistArray.removeLast()
                        }
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
    @State static var array: [ChecklistItemsModel] = []
    static var previews: some View {
        CheckList(checklistArray: $array)
    }
}


struct CheckView: View {
    @Binding var title: String
    @Binding var isChecked: Bool
    
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
            .foregroundColor(isChecked ? Color.secondary : Color.black)
        }
    }
}
