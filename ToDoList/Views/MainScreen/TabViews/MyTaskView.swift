import SwiftUI

struct MyTaskView: View {
    @State private var selected = true
    @State var selection: Int = 0
    
    
    var body: some View {
        VStack {
            
            //MARK: Header
            HStack {
                Spacer()
                Text("Work List")
                    .font(Font(Roboto.thinItalic(size: 20)))
                    .foregroundColor(.white)
                    .padding(.trailing, -40)
                Spacer()
                Button {
                    // some action
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 21)
                        .padding(.trailing, 20)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 107)
            .background(Color.customCoral)
            
            
            

            
        }
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
