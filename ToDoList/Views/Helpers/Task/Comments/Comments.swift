import SwiftUI

struct Comments: View {
    @Binding var comments: [FetchCommentsData]
    @Binding var commentContent: String
    @Binding var commentId: String
    
    @State var deleteComment: () -> ()
    
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
                        Text(comment.createdAt)
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
                deleteComment()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .animation(.default, value: comments)
    }
}

struct Comments_Previews: PreviewProvider {
    @State static var comment: [FetchCommentsData] = []
    @State static var commentContent = ""
    @State static var commentId = ""
    
    static var previews: some View {
        Comments(comments: $comment,
                 commentContent: $commentContent,
                 commentId: $commentId,
                 deleteComment: {})
    }
}
