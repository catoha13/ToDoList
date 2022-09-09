import SwiftUI

struct CreateNote: View {
    @State var description = ""
    @Binding var isPresented: Bool
    @State var selectedColor: Color = .clear
    
    var body: some View {
        VStack {
            //MARK: Header
            Header(text: "Add Note", isPresented: $isPresented)
            //MARK: View
                VStack(alignment: .trailing) {
                    //MARK: Description
                    HStack {
                        Text("Description")
                            .font(Font(Roboto.thinItalic(size: 18)))
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.bottom, 6)
                    TextField(text: $description) {
                        Text("Text here")
                    }
                    .font(Font(Roboto.medium(size: 16)))
                    .padding()
                    .multilineTextAlignment(.leading)
                    
                    ChooseColor(selectedColor: selectedColor)
                        .padding(.trailing, 48)
                }
                .frame(width: 343, height: 468)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
                .offset(y: -40)
                .shadow(radius: 4)
                
           Spacer() // change to Tab Bar?
        }
        .frame(width: 390)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct CreateNote_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateNote(isPresented: $isPresented)
    }
}
