import SwiftUI

struct CreateView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        
            ZStack {
                Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: 20)
                    .background(.secondary)
                
                VStack {
                    NavigationLink {
                        CreateTaskView()
                    } label: {
                        Label {
                            Text("Add Task")
                                .font(Font(Roboto.thinItalic(size: 18)))
                                .foregroundColor(.customBlack)
                        } icon: {}
                            .padding()
                            .frame(width: 220)
                    }
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        Label {
                            Text("Add Quick Note")
                                .font(Font(Roboto.thinItalic(size: 18)))
                                .foregroundColor(.customBlack)
                        } icon: {}
                            .padding()
                            .frame(width: 220)
                    }
                    Divider()
                    
                    NavigationLink {
                        
                    } label: {
                        Label {
                            Text("Add Check List")
                                .font(Font(Roboto.thinItalic(size: 18)))
                                .foregroundColor(.customBlack)
                        } icon: {}
                            .padding()
                            .frame(width: 220)
                    }
                }
                .frame(width: 268, height: 214)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
            }
    }
}

struct CreateView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateView(isPresented: $isPresented)
            .cornerRadius(Constants.radiusFive)
    }
}
