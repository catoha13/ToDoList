import SwiftUI

struct AboutUser: View {
    @Binding var userName: String
    @Binding var userEmail: String
    @Binding var userAvatar: String
    @Binding var createdTask: Int
    @Binding var completedTasks: Int
    @State var showEditView: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                CircleImageView(imageUrl: $userAvatar, width: 64, height: 64)
                VStack(alignment: .leading) {
                    Text(userName)
                        .font(.RobotoThinItalicSmall)
                    Text(userEmail)
                        .font(.RobotoMediumSmall)
                }
                Spacer()
                Button {
                    showEditView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .foregroundColor(.black)
                }
                .frame(width: 20, height: 20)
                .offset(x: 2, y: -42)
            }
            .padding(.top, 30)
            .padding(.horizontal, 10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(createdTask)")
                    Text("Created Task")
                        .font(.RobotoMediumSmall)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(("\(completedTasks)"))
                    Text("Completed Tasks")
                        .font(.RobotoMediumSmall)
                }
            }
            .font(.RobotoThinItalic)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .foregroundColor(.gray)
        .background(.white)
        .frame(width: 343, height: 190)
        .padding()
        .cornerRadius(Constants.radiusFive)
    }
}

struct AboutUser_Previews: PreviewProvider {
    @State static var username = "Stephen Chow"
    @State static var email  = "some23098@mail.com"
    @State static var avatar = "person"
    @State static var createdTask = 0
    @State static var completedTask = 0
    
    static var previews: some View {
        AboutUser(userName: $username,
                  userEmail: $email,
                  userAvatar: $avatar,
                  createdTask: $createdTask,
                  completedTasks: $completedTask,
                  showEditView: {})
    }
}
