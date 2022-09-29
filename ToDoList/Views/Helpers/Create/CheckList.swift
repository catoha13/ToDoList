import SwiftUI

struct CheckList: View {
    @Binding var checklistArray: [ChecklistItemsModel]
    @State var deleteAction = {}
    @State private var emptyItem = ChecklistItemsModel(content: "", isCompleted: false)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach($checklistArray, id: \.self) { item  in
                ChecklistItem(title: item.content,
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
                    checklistArray.append(emptyItem)
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
