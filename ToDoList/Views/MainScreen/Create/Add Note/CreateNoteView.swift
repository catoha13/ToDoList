import SwiftUI

struct CreateNoteView: View {
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel = QuickViewModel()
    @State private var selectedColor: Color = .customBlue
    @State private var isMaxLength = false
    
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
                    .onChange(of: viewModel.noteText) { _ in
                        withAnimation {
                            if viewModel.noteText.count > Constants.maxNoteLenght {
                                isMaxLength = true
                            } else {
                                isMaxLength = false
                            }
                        }
                    }
                
                if isMaxLength {
                    HStack {
                        Text("Note is too long")
                            .foregroundColor(.red)
                        .font(.RobotoThinItalicSmall)
                        .padding(.leading, 30)
                        Spacer()
                    }
                }
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
                    viewModel.selectedNoteColor = selectedColor.convertToHex()
                    viewModel.createNote.send()
                    isPresented.toggle()
                }
                .disabled(isMaxLength)
                .opacity(isMaxLength ? 0.75 : 1)
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
        .navigationBarHidden(true)
    }
}

struct CreateNoteView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateNoteView(isPresented: $isPresented)
    }
}
