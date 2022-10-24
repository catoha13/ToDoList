import SwiftUI

struct CreateTaskView: View {
    @ObservedObject var viewModel = TaskViewModel()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            VStack {
                //MARK: Header
                Header(text: "New Task", isPresented: $isPresented)
                ZStack {
                    //MARK: View
                    VStack(alignment: .center) {
                        HStack {
                            //MARK: Assignee
                            TextFieldAndImage(image: $viewModel.selectedUserAvatar,
                                              text: $viewModel.assigneeName,
                                              description: "Assignee")
                            Spacer()
                            //MARK: Project
                            TextFieldAndText(text: $viewModel.projectName, description: "Project")
                        }
                        .padding(.top, -10)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        
                        //MARK: Title
                        TextField(text: $viewModel.title) {
                            Text("Title")
                        }
                        .padding()
                        .font(Font(Roboto.thinItalic(size: 18)))
                        .frame(height: 66)
                        .background(Color.customBar)
                        
                        //MARK: Description Label
                        HStack {
                            Text("Description")
                                .font(Font(Roboto.regular(size: 16)))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.leading, 24)
                        
                        //MARK: Description Text
                        VStack {
                            TextField(text: $viewModel.description) {
                                Text("Text here")
                                    .font(Font(Roboto.regular(size: 16)))
                            }
                            .padding(.horizontal, 10)
                            Spacer()
                            HStack {
                                //MARK: Attachments
                                Button {
                                    
                                } label: {
                                    Image(systemName: "paperclip")
                                        .resizable()
                                        .frame(width: 19.61, height: 20.54)
                                        .foregroundColor(.secondary)
                                        .padding(.all, 10)
                                    
                                }
                                Spacer()
                            }
                            .background(Color.customBar)
                        }
                        .frame(width: 295, height: 120)
                        .overlay(RoundedRectangle(cornerRadius: Constants.radiusFive)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.customGray))
                        .cornerRadius(Constants.radiusFive)
                        
                        //MARK: Due date
                        HStack {
                            Text("Due Date")
                                .font(.RobotoMediumSmall)
                            Button {
                                withAnimation() {
                                    viewModel.showDatePicker.toggle()
                                }
                            } label: {
                                Text(viewModel.dueDate != nil ? viewModel.formatDate(date: viewModel.dueDate ?? Date()) : viewModel.getDate)
                                    .font(.RobotoMediumSmall)
                            }
                            .frame(width: 105, height: 32)
                            .background(Color.customBlue)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.radiusFive)
                            Spacer()
                        }
                        .padding(.leading, 24)
                        .frame(height: 66)
                        .background(Color.customBar)
                        .padding(.vertical)
                        
                        //MARK: Add Member
                        VStack {
                            HStack {
                                Text("Add Member")
                                    .font(.RobotoMediumSmall)
                                Spacer()
                            }
                            .padding(.horizontal)
                            HStack {
                                if viewModel.members == nil {
                                    Text("Anyone")
                                        .frame(width: 90, height: 58)
                                        .multilineTextAlignment(.center)
                                        .background(Color.customBar)
                                        .cornerRadius(Constants.raidiusFifty)
                                } else {
                                    Text("")
                                        .padding(.leading, 6)
                                    ForEach(viewModel.addedMembersAvatars, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 32, height: 32)
                                            .padding(.vertical, 13)
                                            .onLongPressGesture {
                                                withAnimation {
                                                    if let index = viewModel.addedMembersAvatars.firstIndex(where: { $0 == image}) {
                                                        viewModel.addedMembersAvatars.remove(at: index)
                                                    }
                                                    if let index = viewModel.members?.firstIndex(where: { $0.id == $0.id}) {
                                                        viewModel.members?.remove(at: index)
                                                    }
                                                }
                                                
                                            }
                                    }
                                }
                                Button {
                                    withAnimation {
                                        viewModel.showAddMemberView.toggle()
                                    }
                                } label: {
                                    Text("+")
                                        .frame(width: 32, height: 32)
                                        .font(Font(Roboto.regular(size: 16)))
                                        .background(Color.secondary)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                        .padding(.vertical, 13)
                                    
                                }
                                Spacer()
                            }
                            .animation(.easeInOut, value: viewModel.members == nil)
                        }
                        .padding(.bottom, 30)
                        .padding(.leading, 10)
                        
                        //MARK: Custom Button
                        CustomCoralFilledButton(text: "Add Task") {
                            viewModel.getDate = viewModel.formatDueDate(date: viewModel.dueDate ?? Date())
                            viewModel.createTask()
                        }
                    }
                    .frame(width: 343, height: 682)
                    .background(.white)
                    .cornerRadius(Constants.radiusFive)
                    .offset(y: -40)
                    .shadow(radius: 4)
                    
                    //MARK: SearchUser View
                    if viewModel.assigneeName != viewModel.selectedUser {
                        SearchUserView(mergedArray: $viewModel.mergedUsersAndAvatars,
                                       filteredText: $viewModel.assigneeName,
                                       searchedUser: $viewModel.assigneeName,
                                       searchedUserId: $viewModel.assigneeId,
                                       searchedUserAvatar: $viewModel.selectedUserAvatar) {
                            viewModel.selectedUser = viewModel.assigneeName
                        }
                    }
                    
                    //MARK: SearchProject View
                    if viewModel.projectName != viewModel.selectedProjectName {
                        SearchProjectsView(projects: $viewModel.searchProjectsResoponseArray,
                                           projectName: $viewModel.selectedProjectName,
                                           projectId: $viewModel.selectedProjectId) {
                            viewModel.projectName = viewModel.selectedProjectName
                        }
                    }
                    
                    //MARK: AddMember View
                    if viewModel.showAddMemberView {
                        AddMembersView(isPresented: $viewModel.showAddMemberView,
                                       mergedArray: $viewModel.mergedUsersAndAvatars,
                                       members: $viewModel.members,
                                       membersId: $viewModel.membersId,
                                       membersAvatars: $viewModel.addedMembersAvatars) {
                            viewModel.showAddMemberView.toggle()
                        }
                    }
                }
            }
            .frame(height: 669)
            .navigationBarHidden(true)
            
            //MARK: Custom DatePicker
            if viewModel.showDatePicker {
                CustomDatePicker(isPresented: $viewModel.showDatePicker,
                                 selectedDate: $viewModel.dueDate)
            }
        }
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        CreateTaskView(isPresented: $isPresented)
    }
}
