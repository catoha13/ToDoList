import SwiftUI

struct TaskCell: View {
    @Binding var title: String
    @Binding var time: String
    @Binding var isDone: Bool
    
    @State var updateAction: () -> ()
    @State var editAction: () -> ()
    @State var deleteAction: () -> ()
    
    var body: some View {
        Button(action: {
            updateAction()
        }, label: {
            HStack {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isDone ? Color.customCoral : Color.customBlue)
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .strikethrough(isDone, color: .secondary)
                    Text(trimDate(date: time))
                        .foregroundColor(.secondary)
                        .strikethrough(isDone, color: .secondary)
                }
                .padding(.horizontal, 6)
                .font(Font.RobotoMedium)
                .foregroundColor(isDone ? .secondary : .black)
                Spacer()
                Rectangle()
                    .foregroundColor(isDone ? .customCoral : .customBlue)
                    .frame(width: 4, height: 21)
                    .offset(x: 5)
            }
        })
        .swipeActions {
            HStack {
                DeleteCustomButton {
                    self.deleteAction()
                }
                .tint(.white)
                
                EditCustomButton {
                    self.editAction()
                }
                .tint(.white)
            }
        }
        .frame(width: 343, height: 70)

    }
    func trimDate(date: String) -> String {
        let trimmedDate = date.components(separatedBy: "T")
        let date = trimmedDate.last
        return date ?? ""
    }
}
