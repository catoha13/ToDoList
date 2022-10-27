import SwiftUI

struct SearchUserView: View {
    @Binding var mergedArray: [(Members, UIImage, id: UUID)]
    @Binding var filteredText: String
    @Binding var searchedUser: String
    @Binding var searchedUserId: String
    @Binding var searchedUserAvatar: UIImage?
    @Binding var memberId: [String]?
    @State var action: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(mergedArray, id: \.id) { user, avatar, id in
                if !filteredText.isEmpty &&
                    (user.username.contains(filteredText.lowercased()) || user.email.contains(filteredText.lowercased())) {
                    Button {
                        searchedUser = user.username
                        searchedUserId = user.id
                        searchedUserAvatar = avatar
                        memberId?.append(user.id)
                        action()
                    } label: {
                        HStack {
                            Image(uiImage: avatar)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(user.username)
                                    .font(.RobotoThinItalicSmall)
                                Text(user.email)
                                    .font(.RobotoRegularExtraSmall)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 12)
                    .foregroundColor(.black)
                }
            }
        }
        .background(Color.customBar)
        .padding(.top, 20)
        .frame(width: 343, height: 590)
        .cornerRadius(Constants.radiusFive)
    }
}

struct SearchUserView_Previews: PreviewProvider {
    @State static var mergedArray: [(Members, UIImage, id: UUID)] = []
    @State static var filteredText = ""
    @State static var searchedUser = ""
    @State static var searchedUserId = ""
    @State static var searchedUserAvatar = UIImage(named: "background")
    @State static var member: [String]? = []
    @State static var action = {}
    
    static var previews: some View {
        SearchUserView(mergedArray: $mergedArray,
                       filteredText: $filteredText,
                       searchedUser: $searchedUser,
                       searchedUserId: $searchedUserId,
                       searchedUserAvatar: $searchedUserAvatar,
                       memberId: $member,
                       action: action)
    }
}
