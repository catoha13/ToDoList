import SwiftUI

struct Task: View {
    @Binding var task: String
    @Binding var time: String
    @Binding var color: Color
    @State var deleteAction: () -> ()
//    @State var editAction: () -> ()
    @State private var isDone = false
    
    var body: some View {
        HStack {
            CheckButton(isDone: $isDone)
            VStack(alignment: .leading, spacing: 5) {
                Text(task)
                    .strikethrough(isDone, color: .secondary)
                Text(time)
                    .foregroundColor(.secondary)
                    .strikethrough(isDone, color: .secondary)
            }
            .padding(.horizontal, 6)
            .font(Font.RobotoMedium)
            .foregroundColor(isDone ? .secondary : .black)
            Spacer()
            Rectangle()
                .foregroundColor(color)
                .frame(width: 4, height: 21)
                .padding()
                .offset(x: 7)
        }
        .frame(width: 343, height: 70)
        .swipeActions {
            HStack {
                DeleteCustomButton {
                    self.deleteAction()
                }
                .tint(.red)
                .background(.blue)
                EditCustomButton {
//                    self.editAction()
                }
            }
        }
    }
}

struct Task_Previews: PreviewProvider {
    @State static var task = "Go fishing with Stephen"
    @State static var time = "9:00 AM"
    @State static var color = Color.blue
    
    static var previews: some View {
        Task(task: $task, time: $time, color: $color, deleteAction: {})
            .previewLayout(.fixed(width: 343, height: 70))
    }
}


struct Check: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(Color.customCoral)
    }
}

struct NotCheck: View {
    var body: some View {
        Image(systemName: "circle")
            .foregroundColor(.blue)
    }
}

struct CheckButton: View {
    @State private var isChecked = false
    @Binding var isDone: Bool
    var body: some View {
        Button {
            isChecked.toggle()
            isDone.toggle()
        } label: {
            if isChecked {
                Check()
            } else {
                NotCheck()
            }
        }
        .padding(.horizontal, 10)
    }
}
