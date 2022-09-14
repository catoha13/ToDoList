import SwiftUI

struct CreateNoteView: View {
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel = CreateNoteViewModel()
    @State private var selectedColor: Color = .clear
    
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
                TextEditor(text: $viewModel.noteText)
                    .font(Font(Roboto.medium(size: 16)))
                    .padding()
                    .frame(width: 308, height: 151)
                    .padding(.trailing, 42)
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
                    viewModel.selectedColor = convertColor(color: selectedColor)
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
            .frame(width: 343, height: 468)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .offset(y: -40)
            .shadow(radius: 4)
            
            Spacer()
        }
        .frame(width: 390)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    func convertColor(color: Color) -> String {
        var stringColor = color.description
        stringColor.removeLast()
        stringColor.removeLast()
        return stringColor
    }
}

struct CreateNoteView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateNoteView(isPresented: $isPresented)
    }
}
