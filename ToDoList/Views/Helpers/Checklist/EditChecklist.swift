import SwiftUI

struct EditChecklist: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var color: String
    @Binding var selectedArray: [ChecklistData]
    @Binding var updatedArray: [ChecklistItemsModel]
    @State private var selectedColor: Color = .clear
    @State var action = {}
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            VStack {
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
                    ForEach($selectedArray, id: \.self) { array in
                        CheckList(checklistArray: array.items)
                    }
                    
                    //MARK: Choose Color
                    ChooseColor(selectedColor: $selectedColor)
                        .padding(.trailing, 48)
                    
                    //MARK: Custom Filled Button
                    CustomCoralFilledButton(text: "Done") {
                        for array in selectedArray {
                            updatedArray = array.items
                        }
                        color = selectedColor.convertToHex()
                        action()
                        isPresented.toggle()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 40)
                }
                .frame(width: 343, height: 576)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
                .offset(y: -40)
                .shadow(radius: 4)
                
            }
            .padding(.top, 40)
        }
    }
}

struct EditChecklist_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var title = ""
    @State static var color = ""
    @State static var selectedArray = [ChecklistData]()
    @State static var updatedChecklist = [ChecklistItemsModel]()
    static var previews: some View {
        EditChecklist(isPresented: $isPresented,
                      title: $title,
                      color: $color,
                      selectedArray: $selectedArray,
                      updatedArray: $updatedChecklist)
    }
}
