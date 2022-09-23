import SwiftUI

struct CreateCheckListView: View {
    @State var description = ""
    @Binding var isPresented: Bool
    @State var selectedColor: Color = .clear
    
    var body: some View {
        VStack {
            //MARK: Header
            Header(text: "Add CheckList", isPresented: $isPresented)
            //MARK: View
            VStack(alignment: .trailing) {
                //MARK: Description
                HStack {
                    Text("Title")
                        .font(Font(Roboto.thinItalic(size: 18)))
                        .padding(.horizontal)
                        .padding(.top, 40)
                    Spacer()
                }
                .padding(.bottom, 6)
                TextEditor(text: $description)
                    .font(Font(Roboto.medium(size: 16)))
                    .padding(.vertical, 10)
                    .frame(width: 308, height: 68)
                    .padding(.trailing, 24)
                
                //MARK: CheckList
                CheckList()
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
            .frame(width: 343, height: 576)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .offset(y: -40)
            .shadow(radius: 4)
            
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct CreateCheckListView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateCheckListView(isPresented: $isPresented)
    }
}
