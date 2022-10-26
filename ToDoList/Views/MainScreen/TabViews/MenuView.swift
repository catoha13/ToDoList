import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ScrollView {
                    Text("Projects")
                        .font(.RobotoThinItalicHeader)
                        .padding(.vertical, 50)
                    
                    LazyVGrid(columns: viewModel.flexibleLayout) {
                        ForEach(viewModel.projectsArray, id: \.self) { data in
                            ProjectCell(color: data.color, text: data.title, taskCounter: 8)
                                .onLongPressGesture {
                                    viewModel.selectedProjectId = data.id
                                    viewModel.projectName = data.title
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.isEditing.toggle()
                                    }
                                }
                        }
                    }
                    
                    AddProjectButton() {
                        withAnimation {
                            self.viewModel.isPresented.toggle()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customWhiteBackground)
            
            if viewModel.isPresented {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    ProjectChooseColor(isPresented: $viewModel.isPresented,
                                       extracedColor: $viewModel.chosenColor,
                                       projectName: $viewModel.projectName) {
                        viewModel.createProject()
                        viewModel.projectName = ""
                    }
                    .frame(width: 338)
                    .cornerRadius(Constants.radiusFive)
                    .ignoresSafeArea()
                }
            }
            
            if viewModel.isEditing {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    VStack(spacing: 0) {
                        Button("Delete project") {
                            viewModel.showAlert.toggle()
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Delete «\(viewModel.projectName)» project?"),
                                  message: Text("You cannot undo this action."),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteProject()
                                viewModel.isEditing.toggle()
                                viewModel.showAlert.toggle()
                            })
                        }
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .padding(.horizontal, 30)
                        .background(.white)
                        .font(.RobotoThinItalicSmall)
                        
                        ProjectChooseColor(isPresented: $viewModel.isEditing,
                                           extracedColor: $viewModel.chosenColor,
                                           projectName: $viewModel.projectName) {
                            viewModel.updateProject()
                            viewModel.projectName = ""
                        }
                    }
                    .frame(width: 338)
                    .cornerRadius(Constants.radiusFive)
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
