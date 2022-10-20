import SwiftUI

struct SearchUserView: View {
    @Binding var mergedArray: [(Members, UIImage, id: UUID)]
    @Binding var filteredText: String
    @Binding var searchedUser: String
    @Binding var searchedUserAvatar: UIImage?
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
            
            ScrollView(showsIndicators: false) {
                ForEach(mergedArray, id: \.id) { user, avatar, id in
                    if !filteredText.isEmpty &&
                        (user.username.contains(filteredText.lowercased()) || user.email.contains(filteredText.lowercased())) {
                        Button {
                            searchedUser = user.username
                            searchedUserAvatar = avatar
                            action()
                        } label: {
                            HStack {
                                Image(uiImage: avatar)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 44, height: 44)
                                
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
                        .foregroundColor(.black)
                    } else {
                        
                    }
                }
            }
        }
        .frame(width: 343, height: 600)
        .cornerRadius(Constants.radiusFive)
    }
}

struct SearchUserView_Previews: PreviewProvider {
    @State static var mergedArray: [(Members, UIImage, id: UUID)] = []
    @State static var filteredText = ""
    @State static var searchedUser = ""
    @State static var searchedUserAvatar = UIImage(named: "background")
    @State static var action = {}
    
    static var previews: some View {
        SearchUserView(mergedArray: $mergedArray,
                       filteredText: $filteredText,
                       searchedUser: $searchedUser,
                       searchedUserAvatar: $searchedUserAvatar,
                       action: action)
    }
}
