import SwiftUI

struct EditChecklist: View {
    @Binding var isPresented: Bool
    @Binding var isEditable: Bool
    @Binding var title: String
    @Binding var color: String
    @Binding var itemId: String
    @Binding var selectedArray: [ChecklistItemsModel]
    @Binding var updatedArray: [ChecklistItemsModel]
    
    @State var updateAction = {}
    @State var deleteAction = {}
    @State var createChecklist = {}
    
    @State private var selectedColor: Color = .customBlue
    @State private var isMaxLength = false
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            //MARK: View
            VStack(alignment: .trailing) {
                //MARK: Description
                HStack {
                    Text("Title")
                        .font(Font(Roboto.thinItalic(size: 18)))
                        .padding(.horizontal)
                        .padding(.top, 40)
                    Spacer()
                }
                .padding(.bottom, 6)
                TextField("Enter new name for checklist", text: $title)
                    .font(Font(Roboto.medium(size: 16)))
                    .padding(.vertical, 10)
                    .frame(width: 308, height: 68)
                    .padding(.trailing, 24)
                
                //MARK: CheckList
                CheckList(checklistArray: $selectedArray,
                          isEditable: $isEditable,
                          isMaxLenght: isMaxLength) {
                    deleteAction()
                }
                
                if isMaxLength {
                    HStack {
                        Text("Item name is too long")
                            .foregroundColor(.red)
                            .font(.RobotoThinItalicSmall)
                            .padding(.leading, 30)
                        Spacer()
                    }
                }
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
                    updatedArray = selectedArray
                    for item in selectedArray {
                        itemId = item.id ?? ""
                    }
                    color = selectedColor.convertToHex()
                    updateAction()
                    isPresented.toggle()
                }
                .disabled(isMaxLength)
                .opacity(isMaxLength ? 0.75 : 1)
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
            .frame(width: 343, height: 576)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 4)
        }
    }
}

struct EditChecklist_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var isEditable = false
    @State static var title = ""
    @State static var color = ""
    @State static var itemId = ""
    @State static var selectedArray = [ChecklistItemsModel]()
    @State static var updatedChecklist = [ChecklistItemsModel]()
    static var previews: some View {
        EditChecklist(isPresented: $isPresented,
                      isEditable: $isEditable,
                      title: $title,
                      color: $color,
                      itemId: $itemId,
                      selectedArray: $selectedArray,
                      updatedArray: $updatedChecklist)
    }
}
