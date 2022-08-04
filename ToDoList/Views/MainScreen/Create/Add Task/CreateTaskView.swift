import SwiftUI

struct CreateTaskView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresented: Bool
    @State private var assignee = ""
    @State private var project = ""
    @State private var title = ""
    @State private var description = ""
    @State private var getDate = "Anytime"
    @State private var addTaskPressed = false
    @State private var showSideView = false
    @State private var searchedUser = ""
    
    var body: some View {
        ZStack {
            VStack {
                //MARK: Header
                Header(text: "New Task", isPresented: $isPresented)
                ZStack {
                    //MARK: Bottom View
//                    Bottom()
                    //MARK: View
                    VStack(alignment: .center) {
                        HStack {
                            //MARK: Assignee
                            TextAndTextfield(text: $assignee, description: "Assignee")
                            Spacer()
                            //MARK: Project
                            TextAndTextfield(text: $project, description: "Project")
                        }
                        .padding(.top, -10)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        
                        //MARK: Title
                        TextField(text: $title) {
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
                            TextField(text: $description) {
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
                                Text(getDate)
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
                                Text("Anyone")
                                    .frame(width: 90, height: 58)
                                    .multilineTextAlignment(.center)
                                    .background(Color.customBar)
                                    .cornerRadius(Constants.raidiusFifty)
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
                                addTaskPressed.toggle()
                            }
                        }
                    }
                    .frame(width: 343, height: 672)
                    .background(.white)
                    .cornerRadius(Constants.radiusFive)
                    .offset(y: -40)
                    .shadow(radius: 4)
                    
                    if assignee != searchedUser {
                        //MARK: SearchUser View
                        SearchUserView(filteredText: $assignee,searchedUser: $assignee) {
                            searchedUser = assignee
                        }
                    }
                }
            }
            .frame(width: 390, height: 669)
            
            //MARK: Show ViewTask
            if addTaskPressed {
                ViewTask(title: title,
                         image: "pathFirst",
                         username: assignee,
                         dueDate: "Jul 13, 2022",
                         description: description,
                         tag: project,
                         color: .customBlue,
                         showSideView: $showSideView,
                         closeViewTask: $addTaskPressed)
                .offset(y: -10)
            }
            //MARK: Show SideView
            if showSideView {
                SideView(isPresented: $showSideView,
                         firstText: "Add Member",
                         secondText: "Edit Task",
                         thirdText: "Delete Task")
                .onTapGesture {
                    if showSideView {
                        showSideView.toggle()
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
