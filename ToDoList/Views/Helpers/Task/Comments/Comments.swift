import SwiftUI

struct Comments: View {
    @Binding var comments: [FetchCommentsData]
    @Binding var commentContent: String
    @Binding var commentId: String
    
    @State var loadAvatars: () -> ()
    @State var deleteComment: () -> ()
    
    @State private var showAlert = false
    
    var body: some View {
        ForEach(comments, id: \.self) { comment in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(uiImage: UIImage(named: "superhero")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(comment.commentator?.username ?? " ")
                            .font(.RobotoThinItalicExtraSmall)
                        Text(convertDate(comment.createdAt))
                            .font(.RobotoRegularExtraSmall)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Text(comment.content)
                    .font(.RobotoMediumExtraSmall)
            }
            .onLongPressGesture {
                commentId = comment.id
                commentContent = comment.content
                showAlert.toggle()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .animation(.default, value: comments)
        .alert("Delete comment«\(commentContent)»?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
                comments.removeAll(where: {$0.id == commentId })
            }
            Button("Cancel", role: .cancel) {
                deleteComment()
                showAlert.toggle()
            }
        } message: {
            Text("You cannot undo this action")
        }
    }
}

private func convertDate(_ strDate: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss.ssssss"
    let newDate = formatter.date(from: strDate) ?? Date()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: newDate)
}

struct Comments_Previews: PreviewProvider {
    @State static var comment: [FetchCommentsData] = []
    @State static var commentContent = ""
    @State static var commentId = ""
    
    static var previews: some View {
        Comments(comments: $comment,
                 commentContent: $commentContent,
                 commentId: $commentId,
                 loadAvatars: {},
                 deleteComment: {})
    }
}
