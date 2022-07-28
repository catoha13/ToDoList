import SwiftUI

struct SearchUserView: View {
    @State var users = ["first user", "second user", "third user"]
    @Binding var filteredText: String
    
    var body: some View {
        List {
            ForEach(0..<users.count, id: \.self) {element in
                if !filteredText.isEmpty && users[element].contains(filteredText.lowercased()) {
                    Button {
                        
                    } label: {
                        Text(users[element])
                    }
                } else if filteredText.isEmpty {
                    Button {
                        
                    } label: {
                        Text(users[element])
                    }
                }
            }
        }
        .frame(width: 343, height: 600)
    }
}

struct SearchUserView_Previews: PreviewProvider {
    @State static var users = ["first user", "second user", "third user"]
    @State static var filteredText = ""
    
    static var previews: some View {
        SearchUserView(users: users, filteredText: $filteredText)
    }
}
