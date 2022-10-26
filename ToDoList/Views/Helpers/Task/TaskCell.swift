import SwiftUI

struct TaskCell: View {
    @State var title: String
    @State var time: String
    @State var isDone: Bool
    
    @State var editAction: () -> ()
    @State var deleteAction: () -> ()
    
    var body: some View {
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
        .swipeActions(allowsFullSwipe: false) {
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
        .padding()
        .background(.white)
        .cornerRadius(Constants.radiusFive)
        .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 3)
        .frame(width: 343, height: 70)

    }
    func trimDate(date: String) -> String {
        let trimmedDate = date.components(separatedBy: "T")
        let date = trimmedDate.last
        return date ?? ""
    }
}
