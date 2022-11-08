import SwiftUI

struct ProfileSettings: View {
    @Binding var isPresented: Bool
    
    @State var changeAvatarAction: () -> ()
    @State var signOutAction: () -> ()
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        withAnimation {
                            changeAvatarAction()
                            isPresented.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Change avatar")
                            Spacer()
                        }
                    }
                    
                    Button {
                        withAnimation {
                            signOutAction()
                            isPresented.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Sign Out")
                            Spacer()
                        }
                    }
                }
                .foregroundColor(.black)
                .font(.RobotoThinItalicSmall)
                .frame(width: 140, height: 100)
                .padding(.horizontal)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
            }
            .padding(.bottom, 340)
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            isPresented.toggle()
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        ProfileSettings(isPresented: $isPresented ,changeAvatarAction: {}, signOutAction: {})
    }
}
