import SwiftUI

struct CreateCheckListView: View {
    @EnvironmentObject private var viewModel: QuickViewModel
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var placeholder: LocalizedStringKey = "Name the checklist"
    @State private var warning: LocalizedStringKey = ""
    @State var selectedColor: Color = .customBlue
    
    @State private var isAddItemEnabled = true
    @State private var isMaxLength = false
    
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
                TextField(placeholder, text: $title)
                    .font(Font(Roboto.medium(size: 16)))
                    .padding(.vertical, 10)
                    .frame(width: 308, height: 68)
                    .padding(.trailing, 24)
                
                if isMaxLength {
                    HStack {
                        Text("Item name is too long")
                            .foregroundColor(.red)
                            .font(.RobotoThinItalicSmall)
                            .padding(.leading, 30)
                        Spacer()
                    }
                }
                
                //MARK: CheckList
                CheckList(checklistArray: $viewModel.checklistRequestArray,
                          isEditable: $isAddItemEnabled,
                          isMaxLenght: isMaxLength)
                
                //MARK: Choose Color
                ChooseColor(selectedColor: $selectedColor)
                    .padding(.trailing, 48)
                
                //MARK: Warning
                Text(warning)
                    .font(.RobotoThinItalicFootnote)
                    .foregroundColor(.red)
                    .offset(y: 30)
                    .padding(.trailing, 80)
                    .animation(.default, value: warning)
                
                //MARK: Custom Filled Button
                CustomCoralFilledButton(text: "Done") {
                    if title.isEmpty && viewModel.checklistRequestArray.isEmpty {
                        warning = "Enter the title and add some checklists"
                    } else {
                        viewModel.checklistColor = selectedColor.convertToHex()
                        viewModel.checklistTitle = title
                        viewModel.createChecklist.send()
                        viewModel.checklistRequestArray = []
                        isPresented.toggle()
                    }
                }
                .disabled(isMaxLength)
                .opacity(isMaxLength ? 0.75 : 1)
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
