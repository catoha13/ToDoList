import SwiftUI

struct SearchUserView: View {
    @State var users = ["first user", "second user", "third user"]
    @Binding var filteredText: String
    @Binding var searchedUser: String
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                
            VStack(alignment: .leading) {
                ForEach(0..<users.count, id: \.self) {element in
                    if !filteredText.isEmpty && users[element].contains(filteredText.lowercased()) {
                        Button {
                            searchedUser = users[element]
                            action()
                        } label: {
                            Text(users[element])
                                .padding()
                        }
                    } else if filteredText.isEmpty {
                        Button {
                            searchedUser = users[element]
                            action()
                        } label: {
                            Text(users[element])
                                .padding()
                        }
                    }
                }
                Spacer()
            }
            .padding(.trailing, 140)
        }
        .frame(width: 343, height: 600)
        .cornerRadius(Constants.radiusFive)
    }
}

struct SearchUserView_Previews: PreviewProvider {
    @State static var users = ["first user", "second user", "third user"]
    @State static var filteredText = ""
    @State static var searchedUser = ""
    @State static var action = {}
    
    static var previews: some View {
        SearchUserView(users: users, filteredText: $filteredText,searchedUser: $searchedUser, action: action)
    }
}
