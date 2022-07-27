import SwiftUI

struct CreateTaskView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                
                //MARK: Header
                HStack {
                   BackButton(isPresented: $isPresented)
                    
                    Spacer()
                    
                    Text("Work List")
                        .font(Font(Roboto.thinItalic(size: 20)))
                        .foregroundColor(.white)
                        .padding(.trailing, 40)
                    
                    Spacer()
                }
                .frame(height: 107)
                .background(Color.customCoral)
                
                
                

                
            }
        }
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        CreateTaskView(isPresented: $isPresented)
    }
}
