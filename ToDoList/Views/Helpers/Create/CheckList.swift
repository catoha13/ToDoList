import SwiftUI

struct CheckList: View {
    @Binding var checklistArray: [ChecklistItemsModel]
    @State private var isCompleted = false
    @State private var title = ""
    @State var deleteAction = {}
    private var item: ChecklistItemsModel {
        ChecklistItemsModel(content: title, isCompleted: isCompleted)
    }
    
    var body: some View {
        ScrollView {
            ForEach($checklistArray, id: \.self) { item  in
                CheckView(title: item.content,
                          isChecked: item.isCompleted,
                          deleteAction: {
                    if let index = checklistArray.firstIndex(where: {$0.id == $0.id}) {
                        checklistArray.remove(at: index)
                    }
                    deleteAction()
                })
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
                Spacer()
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
    @State var id: String?
    @State var deleteAction = {}
    
    func toggle() {
        isChecked = !isChecked
    }
    var body: some View {
        HStack{
            //MARK: Check button
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(.secondary)
                    .background(Color.customBar)
            }
            TextField(text: $title, label: {
                Text("List item")
            })
            .foregroundColor(isChecked ? Color.secondary : Color.black)
            
            //MARK: Delete Button
            Button {
                deleteAction()
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
}


extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
