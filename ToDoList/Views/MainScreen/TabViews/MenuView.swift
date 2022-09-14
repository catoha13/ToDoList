import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
    @State private var isPresented = false
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var selectedColor = ""
    @State private var projectName = ""
    private var flexibleLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ScrollView {
                    Text("Projects")
                        .font(.RobotoThinItalicHeader)
                        .padding(.vertical, 50)
                    
                    LazyVGrid(columns: flexibleLayout) {
                        ForEach(viewModel.projectsArray, id: \.self) { data in
                            ProjectCell(color: data.color, text: data.title, taskCounter: 8)
                                .onLongPressGesture {
                                    viewModel.selectedProject = data.id
                                    projectName = data.title
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isEditing.toggle()
                                    }
                                }
                        }
                    }
                    
                    AddProjectButton() {
                        withAnimation {
                            self.isPresented.toggle()
                        }
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
                    ProjectChooseColor(isPresented: $isPresented, extracedColor: $selectedColor, projectName: $projectName) {
                        viewModel.chosenColor = selectedColor
                        viewModel.projectName = projectName
                        viewModel.createProject()
                        viewModel.fetchProjects()
                        projectName = ""
                    }
                    .frame(width: 338)
                    .cornerRadius(Constants.radiusFive)
                    .ignoresSafeArea()
                }
            }
            
            if isEditing {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    VStack(spacing: 0) {
                        Button("Delete project") {
                            showAlert.toggle()
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Are you sure?"), message: Text("This action is irreversible.") , primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteProject()
                                isEditing = false
                                showAlert = false
                            }, secondaryButton: .default(Text("Go back")))
                        }
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .padding(.horizontal, 30)
                        .background(.white)
                        .font(.RobotoThinItalicSmall)
                        
                        ProjectChooseColor(isPresented: $isEditing,
                                           extracedColor: $selectedColor,
                                           projectName: $projectName) {
                            viewModel.chosenColor = selectedColor
                            viewModel.projectName = projectName
                            viewModel.updateProject()
                            projectName = ""
                        }
                    }
                    .frame(width: 338)
                    .cornerRadius(Constants.radiusFive)
                }
            }
        }
        .onAppear {
            viewModel.fetchProjects()
        }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
