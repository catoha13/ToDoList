import SwiftUI

struct AddMembersView: View {
    @Binding var isPresented: Bool
    @Binding var mergedArray: [(Member, UIImage, id: UUID)]
    @Binding var members: [Member]?
    @Binding var membersId: [String]?
    @Binding var membersAvatars: [UIImage]
    @State var action: () -> ()
    
    var body: some View {
        ZStack {
            Text("")
                .background(Color.customBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ScrollView(showsIndicators: false) {
                ForEach(mergedArray, id: \.id) { user, avatar, id in
                    Button {
                        withAnimation(.default) {
                            members?.append(user)
                            membersId?.append(user.id)
                            membersAvatars.append(avatar)
                            action()
                        }
                    } label: {
                        HStack {
                            Image(uiImage: avatar)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 44, height: 44)
                                .padding(.horizontal, -4)
                            
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
                }
            }
        }
        .frame(width: 343, height: 530)
        .padding(.top, 50)
        .background(Color.customBar)
        .cornerRadius(Constants.radiusFive)
    }
}

struct AddMembersView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var mergedArray: [(Member, UIImage, id: UUID)] = []
    @State static var members: [Member]? = []
    @State static var membersId: [String]? = []
    @State static var membersAvatars: [UIImage] = []
    
    static var previews: some View {
        AddMembersView(isPresented: $isPresented,
                       mergedArray: $mergedArray,
                       members: $members,
                       membersId: $membersId,
                       membersAvatars: $membersAvatars,
                       action: {})
    }
}
