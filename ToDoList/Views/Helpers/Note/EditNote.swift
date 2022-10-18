import SwiftUI

struct EditNote: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var color: String
    @State var updateAction: () -> ()
    @State private var isMaxLength = false
    
    @State private var selectedColor: Color = .customBlue
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            VStack {
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
                    TextEditor(text: $title)
                        .font(Font(Roboto.medium(size: 16)))
                        .padding()
                        .frame(width: 308, height: 151)
                        .padding(.trailing, 42)
                        .onChange(of: title) { _ in
                            withAnimation {
                                if title.count > Constants.maxNoteLenght {
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
                        color = selectedColor.convertToHex()
                        updateAction()
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
                .padding(.horizontal)
                .padding(.top, 140)
                .shadow(radius: 4)
                
                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
}

struct EditNote_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var title = ""
    @State static var color = ""
    static var previews: some View {
        EditNote(isPresented: $isPresented, title: $title, color: $color,updateAction: {})
    }
}
