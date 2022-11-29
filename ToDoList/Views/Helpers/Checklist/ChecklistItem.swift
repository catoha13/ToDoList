import SwiftUI

struct ChecklistItem: View {
    @Binding var content: String
    @Binding var isCompleted: Bool
    @State var isMaxLength = false
    @State var deleteAction = {}
        
    var body: some View {
        HStack{
            //MARK: Check button
            Button(action: toggle) {
                Image(systemName: isCompleted ? "checkmark.square" : "square")
                    .foregroundColor(.secondary)
                    .background(Color.customBar)
            }
            //MARK: Content
            TextField(text: $content, label: {
                Text("List item")
            })
            
            .foregroundColor(isCompleted ? Color.secondary : Color.black)
            .onChange(of: content) { _ in
                withAnimation {
                    if content.count > Constants.maxChecklistLenght {
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
    
    private func toggle() {
        isCompleted = !isCompleted
    }
}
