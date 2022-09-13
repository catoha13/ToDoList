import SwiftUI

struct ProjectChooseColor: View {
    @Binding var isPresented: Bool
    @Binding var extracedColor: String
    @Binding var projectName: String
    @State var action: () -> ()
    @State private var selectedColor: Color = .red

    
    var body: some View {
        VStack {
            HStack {
                Text("Title")
                    .font(.RobotoThinItalicSmall)
                .padding(.horizontal, 72)
                .padding(.vertical, 20)
                .padding(.leading, -22)
                Spacer()
            }
            
            TextField(text: $projectName) {
                Text("Project Name")
                    .font(.RobotoThinItalicSmall)
            }
            .font(.RobotoRegularSmall)
            .padding(.horizontal, 50)
            .padding(.bottom, 60)
            
            ChooseColor(selectedColor: $selectedColor)
            
            ColorConfirmButton {
                extracedColor = selectedColor.description
                extracedColor.removeLast()
                extracedColor.removeLast()
                isPresented.toggle()
                self.action()
            }
        }
        .background(.white)
    }
}

struct ProjectChooseColor_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var selectedColor: Color = .red
    @State static var projectName = ""
    @State static var extractedColor = ""
    
    
    static var previews: some View {
        ProjectChooseColor(isPresented: $isPresented,
                           extracedColor: $extractedColor,
                           projectName: $projectName,
                           action: {})
    }
}
