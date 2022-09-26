import SwiftUI

struct EditChecklist: View {
//    @Binding var chosenChecklist
    @Binding var isPresented: Bool
    @State private var title = ""
    @State var selectedColor: Color = .clear
    var body: some View {
        VStack {
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
                TextField("Name the checklist", text: $title)
                    .font(Font(Roboto.medium(size: 16)))
                    .padding(.vertical, 10)
                    .frame(width: 308, height: 68)
                    .padding(.trailing, 24)
                
                //MARK: CheckList
                // chosen element from array
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
//                    viewModel.color = viewModel.convertColor(color: selectedColor)
//                    viewModel.title = title
//                    viewModel.createChecklist()
                    isPresented.toggle()
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
            .frame(width: 343, height: 576)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .offset(y: -40)
            .shadow(radius: 4)
            
        }
        .padding(.top, 40)
    }
}

struct EditChecklist_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        EditChecklist(isPresented: $isPresented)
    }
}
