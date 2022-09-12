import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
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
                    
                    ForEach(viewModel.projectsArray, id: \.self) { data in
                        ProjectCell(color: data.color, text: data.title, taskCounter: 8)
                        
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
        .onAppear {
//            viewModel.fetchProjects()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
