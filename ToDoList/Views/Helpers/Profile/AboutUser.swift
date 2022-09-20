import SwiftUI

struct AboutUser: View {
    @State var userName = "Stephen Chow"
    @State var userEmail = "some23098@mail.com"
    @State var userAvatar = "person"
    @State var createdTask = "0"
    @State var completedTasks = "0"
    @State var showEditView: () -> ()
    var body: some View {
        VStack {
            HStack {
                CircleImageView(image: userAvatar, width: 64, height: 64)
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
                    Text(createdTask)
                    Text("Created Task")
                        .font(.RobotoMediumSmall)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(completedTasks)
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
    static var previews: some View {
        AboutUser(showEditView: {})
    }
}
