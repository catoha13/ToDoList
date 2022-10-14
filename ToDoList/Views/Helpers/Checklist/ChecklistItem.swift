import SwiftUI

struct ChecklistItem: View {
    @Binding var title: String
    @Binding var isChecked: Bool
    @State var id: String?
    @State var isMaxLength = false
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
            .onChange(of: title) { _ in
                withAnimation {
                    if title.count > Constants.maxChecklistLenght {
                        isMaxLength = true
                    } else {
                        isMaxLength = false
                    }
                }
            }
            
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
