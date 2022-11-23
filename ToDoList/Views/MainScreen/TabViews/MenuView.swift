import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                VStack {
                    Text("Projects")
                        .font(.RobotoThinItalicHeader)
                        .padding(.vertical, 50)
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: viewModel.flexibleLayout) {
                            ForEach(viewModel.projectsArray.value.sorted { $0.createdAt ?? "" > $1.createdAt ?? "" }, id: \.self) { data in
                                ProjectCell(color: data.color ?? "", text: data.title ?? "", taskCounter: 8)
                                    .onLongPressGesture {
                                        viewModel.selectedProjectId.value = data.id ?? ""
                                        viewModel.projectName.value = data.title ?? ""
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if viewModel.isOffline.value {
                                                return
                                            } else {
                                                viewModel.isEditing.value.toggle()
                                            }
                                        }
                                    }
                            }
                        }
                        .animation(.default, value: viewModel.projectsArray.value)
                        
                        AddProjectButton() {
                            withAnimation {
                                self.viewModel.showCreateProject.value.toggle()
                            }
                        }
                        .disabled(viewModel.isOffline.value)
                    }
                    .alert(isPresented: $viewModel.isOffline.value) {
                        Alert(title: Text("Something went wrong"), message: Text(viewModel.alertMessage.value), dismissButton: Alert.Button.cancel(Text("Ok")))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customWhiteBackground)
            
            if viewModel.showCreateProject.value {
                ZStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.secondary)
                        .onTapGesture {
                            viewModel.showCreateProject.value.toggle()
                        }
                    ProjectChooseColor(isPresented: $viewModel.showCreateProject.value,
                                       extracedColor: $viewModel.chosenColor.value,
                                       projectName: $viewModel.projectName.value) {
                        viewModel.createProjectRequest.send()
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
                        .onTapGesture {
                            viewModel.isEditing.value.toggle()
                        }
                    VStack(spacing: 0) {
                        Button("Delete project") {
                            viewModel.showDeleteAlert.value.toggle()
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $viewModel.showDeleteAlert.value) {
                            Alert(title: Text("Delete «\(viewModel.projectName.value)» project?"),
                                  message: Text("You cannot undo this action."),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteProjectRequest.send()
                                viewModel.isEditing.value.toggle()
                                viewModel.showDeleteAlert.value.toggle()
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
                            viewModel.updateProjectRequest.send()
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
