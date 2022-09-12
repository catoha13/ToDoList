import SwiftUI

struct ProjectChooseColor: View {
    @Binding var isPresented: Bool
    @Binding var selectedColor: Color
    @Binding var projectName: String
    
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
            
            ChooseColor(selectedColor: selectedColor)
            
            ColorConfirmButton {
                isPresented.toggle()
            }
        }
        .background(.white)
    }
}

struct ProjectChooseColor_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var selectedColor: Color = .red
    @State static var projectName = ""
    
    
    static var previews: some View {
        ProjectChooseColor(isPresented: $isPresented, selectedColor: $selectedColor, projectName: $projectName)
    }
}
