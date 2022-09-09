import SwiftUI

struct MenuView: View {
    @State private var isPresented = false
    @State private var selectedColor: Color = .red
    @State private var projectName = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ScrollView {
                Text("Projects")
                    .font(.RobotoThinItalicHeader)
                    .padding(.vertical, 50)
                
                ForEach(0..<1) { _ in
                    HStack {
                        ProjectCell()
                        ProjectCell()
                    }
                }
                AddProjectButton() {
                    self.isPresented.toggle()
                }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customWhiteBackground)
            
            if isPresented {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    ProjectChooseColor(isPresented: $isPresented, selectedColor: $selectedColor, projectName: $projectName)
                        .frame(width: 338)
                        .cornerRadius(Constants.radiusFive)
                        .ignoresSafeArea()
                    
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
