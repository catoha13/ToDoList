import SwiftUI

struct EditableChecklist: View {
    @State var checklistArray: [ChecklistItemsModel]
    @State private var isCompleted = false
    @State private var title = ""
    private var item: ChecklistItemsModel {
        ChecklistItemsModel(content: title, isCompleted: isCompleted)
    }
    
    var body: some View {
        ScrollView {
            ForEach($checklistArray, id: \.self) { element  in
                HStack {
                    CheckView(title: element.content, isChecked: element.isCompleted )
                        .padding(.vertical, 10)
                    //MARK: Delete Button
                    Spacer()
                    ForEach(checklistArray, id: \.self) { array in
                        Button {
                            if let index = checklistArray.firstIndex(where: {$0.id == array.id}) {
                                checklistArray.remove(at: index)
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
            }
                //MARK: Add Button
                Button {
                    checklistArray.append(item)
                } label: {
                    Text("+ Add new item")
                        .font(Font(Roboto.thinItalic(size: 16)))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                
        }
        .frame(height: 192)
        .padding()
    }
}

struct EditableChecklist_Previews: PreviewProvider {
    @State static var array: [ChecklistItemsModel] = []
    
    static var previews: some View {
        EditableChecklist(checklistArray: array)
    }
}
