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
                            TextAndTextfield(text: $viewModel.assignee, description: "Assignee")
                            Spacer()
                            //MARK: Project
                            TextAndTextfield(text: $viewModel.projectName, description: "Project")
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
                        
                        HStack {
                            Text("Due Date")
                            Button {
                                
                            } label: {
                                Text(viewModel.getDate)
                            }
                            .frame(width: 90, height: 32)
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
                                    .font(Font(Roboto.regular(size: 16)))
                                Spacer()
                            }
                            .padding(.horizontal)
                            HStack {
                                if viewModel.selectedUsers.isEmpty {
                                    Text("Anyone")
                                        .frame(width: 90, height: 58)
                                        .multilineTextAlignment(.center)
                                        .background(Color.customBar)
                                        .cornerRadius(Constants.raidiusFifty)
                                } else {
                                    ForEach(viewModel.selectedUsers, id: \.id) { user in
                                        Text(user.email)
                                    }
                                }
                                Button {
                                    
                                } label: {
                                    Text("+")
                                        .frame(width: 32, height: 32)
                                        .font(Font(Roboto.regular(size: 16)))
                                        .background(Color.secondary)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                    
                                }
                                Spacer()
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        .padding(.leading, 10)
                        
                        //MARK: Custom Button
                        CustomCoralFilledButton(text: "Add Task") {
                            withAnimation {
                                viewModel.addTaskPressed.toggle()
                            }
                        }
                    }
                    .frame(width: 343, height: 672)
                    .background(.white)
                    .cornerRadius(Constants.radiusFive)
                    .offset(y: -40)
                    .shadow(radius: 4)
                    
                    if viewModel.assignee != viewModel.searchedUser {
                        //MARK: SearchUser View
                        SearchUserView(selectedUsers: $viewModel.selectedUsers,
                                       users: $viewModel.searchUsersArray,
                                       filteredText: $viewModel.assignee,
                                       searchedUser: $viewModel.assignee) {
                            viewModel.searchedUser = viewModel.assignee
                        }
                    }
                }
            }
            .frame(height: 669)
            
            //MARK: Show ViewTask
            if viewModel.addTaskPressed {
                ViewTask(title: viewModel.title,
                         image: "pathFirst",
                         username: viewModel.assignee,
                         dueDate: "Jul 13, 2022",
                         description: viewModel.description,
                         tag: viewModel.projectName,
                         color: .customBlue,
                         showSideView: $viewModel.showSideView,
                         closeViewTask: $viewModel.addTaskPressed)
                .offset(y: -10)
            }
            //MARK: Show SideView
            if viewModel.showSideView {
                SideView(isPresented: $viewModel.showSideView,
                         firstText: "Add Member",
                         secondText: "Edit Task",
                         thirdText: "Delete Task")
                .onTapGesture {
                    if viewModel.showSideView {
                        viewModel.showSideView.toggle()
                    }
                }
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        CreateTaskView(isPresented: $isPresented)
    }
}
