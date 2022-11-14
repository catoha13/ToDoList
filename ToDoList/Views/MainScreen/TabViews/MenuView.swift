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
                        ForEach(viewModel.projectsArray.value, id: \.self) { data in
                            ProjectCell(color: data.color, text: data.title, taskCounter: 8)
                                .onLongPressGesture {
                                    viewModel.selectedProjectId.value = data.id
                                    viewModel.projectName.value = data.title
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.isEditing.value.toggle()
                                    }
                                }
                        }
                    }
                    .animation(.default, value: viewModel.projectsArray.value)
                    
                    AddProjectButton() {
                        withAnimation {
                            self.viewModel.isPresented.value.toggle()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customWhiteBackground)
            
            if viewModel.isPresented.value {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    ProjectChooseColor(isPresented: $viewModel.isPresented.value,
                                       extracedColor: $viewModel.chosenColor.value,
                                       projectName: $viewModel.projectName.value) {
                        viewModel.createProject()
                        viewModel.projectName.value = ""
                    }
                    .frame(width: 338)
                    .cornerRadius(Constants.radiusFive)
                    .ignoresSafeArea()
                }
            }
            
            if viewModel.isEditing.value {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                    VStack(spacing: 0) {
                        Button("Delete project") {
                            viewModel.showAlert.value.toggle()
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $viewModel.showAlert.value) {
                            Alert(title: Text("Delete «\(viewModel.projectName.value)» project?"),
                                  message: Text("You cannot undo this action."),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteProject()
                                viewModel.isEditing.value.toggle()
                                viewModel.showAlert.value.toggle()
                            })
                        }
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .padding(.horizontal, 30)
                        .background(.white)
                        .font(.RobotoThinItalicSmall)
                        
                        ProjectChooseColor(isPresented: $viewModel.isEditing.value,
                                           extracedColor: $viewModel.chosenColor.value,
                                           projectName: $viewModel.projectName.value) {
                            viewModel.updateProject()
                            viewModel.projectName.value = ""
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
