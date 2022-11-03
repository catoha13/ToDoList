import SwiftUI

struct CompleteTask: View {
    @Binding var isPresented: Bool
    @Binding var isCompleted: Bool
    
    @Binding var title: String
    @Binding var members: [Members]?
    @Binding var membersAvatars: [UIImage]
    @Binding var membersId: [String]?
    @Binding var dueDate: String
    @Binding var description: String
    @State var tag = "Personal"
    @State var color: Color = .customBlue
    
    @Binding var commentText: String
    @Binding var comments: [FetchCommentsData]
    @Binding var commentId : String
    
    @Binding var mergedArray: [(Members, UIImage, id: UUID)]
    
    @State var updateAction: () -> ()
    @State var addMembersAction: () -> ()
    @State var deleteTaskAction: () -> ()
    @State var createCommentAction: () -> ()
    @State var deleteCommentAction: () -> ()
    
    @State private var addedMembers: [Members]? = []
    @State private var addedMembersAvatars: [UIImage] = []
    @State private var addedMmembersId: [String]? = []
    @State private var commentContent = ""
    
    @State private var isEditOn = false
    @State private var showComments = false
    @State private var showSettingsView: Bool = false
    @State private var showTaskAlert = false
    @State private var showAddMembers = false
    @State private var showCommentAlert = false
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            ScrollView(showsIndicators: false) {
                VStack {
                    //MARK: Buttons
                    HStack {
                        Button {
                            if isEditOn {
                                withAnimation {
                                    isEditOn.toggle()
                                }
                            } else {
                                isPresented.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .rotationEffect(Angle(degrees: 45))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        if isEditOn {
                            Text("Editing")
                                .font(.RobotoRegularSmall)
                        }
                        Spacer()
                        Button {
                            withAnimation(.default) {
                                showSettingsView.toggle()
                            }
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .rotationEffect(showSettingsView ? .degrees(180) : .degrees(0))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    //MARK: Title
                    HStack {
                        if isEditOn {
                            TextField("Enter new title", text: $title)
                        } else {
                            Text(title)
                            Spacer()
                        }
                    }
                    .font(Font(Roboto.thinItalic(size: 18)))
                    .padding(.horizontal, 26)
                    
                    //MARK: Assigned to
                    VStack {
                        HStack {
                            Image(uiImage: membersAvatars.last ?? UIImage(named: "background")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Assigned to")
                                    .font(Font(Roboto.regular(size: 16)))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 01)
                                Text(members?.last?.username ?? " ")
                                    .font(Font(Roboto.thinItalic(size: 16)))
                            }
                            Spacer()
                        }
                        Divider()
                            .frame(width: 295)
                            .padding(.top, -10)
                    }
                    .padding(.vertical, -10)
                    
                    //MARK: Due Date
                    VStack {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                                .frame(width: 44, height: 44)
                                .offset(y: -14)
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Due Date")
                                    .font(Font(Roboto.regular(size: 16)))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 1)
                                Text(trimDate(date: dueDate))
                                    .font(Font(Roboto.thinItalic(size: 16)))
                            }
                            Spacer()
                        }
                        Divider()
                            .frame(width: 295)
                            .padding(.vertical, -10)
                    }
                    .padding(.top, -10)
                    
                    //MARK: Description
                    VStack {
                        HStack {
                            Image(systemName: "doc.plaintext")
                                .foregroundColor(.secondary)
                                .frame(width: 44, height: 44)
                                .offset(y: -22)
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Description")
                                    .font(Font(Roboto.regular(size: 16)))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 1)
                                if isEditOn {
                                    TextField("Enter new description", text: $description)
                                        .font(Font(Roboto.regular(size: 16)))
                                        .lineLimit(2)
                                    Spacer()
                                } else {
                                    Text(description)
                                        .font(Font(Roboto.regular(size: 16)))
                                        .lineLimit(2)
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                        Divider()
                            .frame(width: 295)
                            .padding(.vertical, -10)
                    }
                    .padding(.top, -10)
                    
                    //MARK: Members
                    VStack {
                        HStack {
                            Image(systemName: "person.3")
                                .foregroundColor(.secondary)
                                .frame(width: 44, height: 44)
                                .offset(y: -22)
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Members")
                                    .font(Font(Roboto.regular(size: 16)))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 1)
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(membersAvatars, id: \.self) { avatar in
                                            Image(uiImage: avatar)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        Divider()
                            .frame(width: 295)
                            .padding(.vertical, -10)
                    }
                    .padding(.top, -10)
                    
                    //MARK: Tag
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.secondary)
                            .frame(width: 44, height: 44)
                            .offset(y: -22)
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Tag")
                                .font(Font(Roboto.regular(size: 16)))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 1)
                            Text(tag)
                                .frame(width: 90, height: 40)
                                .overlay(RoundedRectangle(cornerRadius: Constants.radiusFive)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.customGray))
                                .foregroundColor(color)
                            
                        }
                        Spacer()
                    }
                    //MARK: Show Comments
                    if showComments {
                        VStack {
                            CommentsView(text: $commentText,
                                         sendAction: {
                                createCommentAction()
                            })
                            .padding(.vertical)
                            
                            Comments(comments: $comments,
                                     commentContent: $commentContent,
                                     commentId: $commentId,
                                     deleteComment: {
                                deleteCommentAction()
                                showCommentAlert.toggle()
                            })
                        }
                    }
                    
                    //MARK: Confirm button
                    if isEditOn {
                        CustomBlueFilledButton(text: "Done") {
                            withAnimation {
                                for user in members ?? [] {
                                    membersId?.append(user.id)
                                }
                                isEditOn.toggle()
                                updateAction()
                            }
                        }
                        .padding(.top, 10)
                    } else {
                        CustomBlueFilledButton(text: isCompleted ? "Undo completion" : "Complete Task") {
                            updateAction()
                            isPresented.toggle()
                        }
                        .padding(.top, 10)
                    }
                    
                    //MARK: Comment Button
                    if !isEditOn {
                        Button {
                            withAnimation {
                                showComments.toggle()
                            }
                        } label: {
                            HStack {
                                Text("Comment")
                                    .font(Font(Roboto.thinItalic(size: 17)))
                                VStack {
                                    Image(systemName: "chevron.down")
                                        .offset(y: 4)
                                        .foregroundColor(Color.customGray)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .rotationEffect(Angle(degrees: showComments ? -180 : 0))
                            }
                        }
                        .padding()
                        .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 343, height: 646)
            .padding(.top, 10)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 4)
            
            if showSettingsView {
                TaskSettings(isPresented: $showSettingsView,
                             addMemberAction: {
                    showAddMembers.toggle()
                }, editAction: {
                    showSettingsView.toggle()
                    isEditOn.toggle()
                }, deleteAction: {
                    showTaskAlert.toggle()
                })
            }
            
            if showAddMembers {
                AddMembersView(isPresented: $showAddMembers,
                               mergedArray: $mergedArray,
                               members: $addedMembers,
                               membersId: $addedMmembersId,
                               membersAvatars: $addedMembersAvatars) {
                    members?.insert(contentsOf: addedMembers ?? [], at: 0)
                    membersAvatars.insert(contentsOf: addedMembersAvatars, at: 0)
                    membersId?.insert(contentsOf: addedMmembersId ?? [], at: 0)
                    addedMembers = []
                    addedMembersAvatars = []
                    addedMmembersId = []
                    addMembersAction()
                    showAddMembers.toggle()
                }
            }
        }
        .alert("Delete «\(title)» task?", isPresented: $showTaskAlert) {
            Button("Delete", role: .destructive) {
                deleteTaskAction()
                isPresented.toggle()
            }
            Button("Cancel", role: .cancel) {
                showTaskAlert.toggle()
            }
        } message: {
            Text("You cannot undo this action")
        }
        .alert("Delete comment«\(commentContent)»?", isPresented: $showCommentAlert) {
            Button("Delete", role: .destructive) {
                //                deleteAction()
                //                isPresented.toggle()
            }
            Button("Cancel", role: .cancel) {
                showCommentAlert.toggle()
            }
        } message: {
            Text("You cannot undo this action")
        }
        
    }
    private func trimDate(date: String) -> String {
        var trimmedDate = date
        for _ in 0..<16 {
            trimmedDate.removeLast()
        }
        return trimmedDate
    }
}

struct CompleteTask_Previews: PreviewProvider {
    @State static var closeViewTask = false
    @State static var isCompleted = false
    @State static var title = ""
    @State static var members: [Members]? = []
    @State static var membersAvatars: [UIImage] = []
    @State static var membersId: [String]? = []
    @State static var dueDate = ""
    @State static var description = ""
    @State static var commentText = ""
    @State static var comments: [FetchCommentsData] = []
    @State static var commentId = ""
    @State static var mergedArray: [(Members, UIImage, id: UUID)] = []
    
    static var previews: some View {
        CompleteTask( isPresented: $closeViewTask,
                      isCompleted: $isCompleted,
                      title: $title,
                      members: $members,
                      membersAvatars: $membersAvatars,
                      membersId: $membersId,
                      dueDate: $dueDate,
                      description: $description,
                      commentText: $commentText,
                      comments: $comments,
                      commentId: $commentId,
                      mergedArray: $mergedArray,
                      updateAction: {},
                      addMembersAction: {},
                      deleteTaskAction: {},
                      createCommentAction: {},
                      deleteCommentAction: {})
    }
}
