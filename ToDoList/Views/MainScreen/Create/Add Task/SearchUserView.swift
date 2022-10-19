import SwiftUI

struct SearchUserView: View {
    @Binding var selectedUsers: [Members]
    @Binding var users: [Members]
    @Binding var filteredText: String
    @Binding var searchedUser: String
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
            
            ScrollView(showsIndicators: false) {
                ForEach(users, id: \.id) { user in
                    if !filteredText.isEmpty &&
                        (user.username.contains(filteredText.lowercased()) || user.email.contains(filteredText.lowercased())) {
                        Button {
                            searchedUser = user.username
                            self.selectedUsers.append(user)
                        } label: {
                            HStack {
                               
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(user.username)
                                        .font(.RobotoThinItalicSmall)
                                    Text(user.email)
                                        .font(.RobotoRegularExtraSmall)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }

                    }
                   
                }
            }
        }
        .frame(width: 343, height: 600)
        .cornerRadius(Constants.radiusFive)
    }
}

struct SearchUserView_Previews: PreviewProvider {
//    @State static var users = ["first user", "second user", "third user"]
    @State static var users = [Members]()
    @State static var filteredText = ""
    @State static var searchedUser = ""
    @State static var action = {}
    
    static var previews: some View {
        SearchUserView(selectedUsers: $users, users: $users, filteredText: $filteredText,searchedUser: $searchedUser, action: action)
    }
}
