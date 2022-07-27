import SwiftUI

struct CreateView: View {
    @Binding var isPresented: Bool
    @State private var isCreateViewPresented = false
    
    var body: some View {
        
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: 20)
                .background(.secondary)
            
            VStack {
                CustomCreateButton(action: {
                    isCreateViewPresented.toggle()
                }, text: "Add Task")
                .padding()
                .frame(width: 220)
                
                Divider()
                
                CustomCreateButton(action: {
                    
                }, text: "Add Quick Note")
                .padding()
                .frame(width: 220)
                
                Divider()
                
                CustomCreateButton(action: {
                    
                }, text: "Add Check List")
                .padding()
                .frame(width: 220)
                
            }
            .frame(width: 268, height: 214)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
        }
        .fullScreenCover(isPresented: $isCreateViewPresented) {
            CreateTaskView(isPresented: $isCreateViewPresented)
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
