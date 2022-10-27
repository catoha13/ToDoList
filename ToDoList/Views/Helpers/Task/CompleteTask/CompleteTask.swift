import SwiftUI

struct CompleteTask: View {
    @Binding var isPresented: Bool
    
    @Binding var title: String
    @Binding var members: [Members]?
    @Binding var membersAvatars: [UIImage]
    @Binding var dueDate: String
    @Binding var description: String
    //MARK: Tag
    @State var tag = "Personal"
    @State var color: Color = .customBlue
    
    @State var updateAction: () -> ()
    @State var deleteAction: () -> ()
    
    @State private var showComments = false
    @State private var showSettingsView: Bool = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    //MARK: Buttons
                    HStack {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .rotationEffect(Angle(degrees: 45))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
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
                        Text(title)
                            .font(Font(Roboto.thinItalic(size: 18)))
                            .padding(.horizontal, 26)
                        Spacer()
                    }
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
                                Text(description)
                                    .font(Font(Roboto.regular(size: 16)))
                                    .lineLimit(2)
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
                        CommentsView()
                            .padding(.vertical)
                    }

                    CustomBlueFilledButton(text: "Complete Task") {
                        updateAction()
                    }
                    .padding(.top, 10)
                    
                    //MARK: Comment Button
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
            .frame(width: 343, height: 646)
            .padding(.top, 10)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 4)
            
            if showSettingsView {
                TaskSettings(isPresented: $showSettingsView,
                             addMemberAction: {
                    
                }, editAction: {
                    
                }, deleteAction: {
                    showAlert.toggle()
                })
            }

        }
        .alert("Delete «\(title)» task?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
                deleteAction()
                isPresented.toggle()
            }
            Button("Cancel", role: .cancel) {
                showAlert.toggle()
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
    @State static var title = ""
    @State static var members: [Members]? = []
    @State static var membersAvatars: [UIImage] = []
    @State static var dueDate = ""
    @State static var description = ""
    
    static var previews: some View {
        CompleteTask( isPresented: $closeViewTask,
                      title: $title,
                      members: $members,
                      membersAvatars: $membersAvatars,
                      dueDate: $dueDate,
                      description: $description,
                      updateAction: {},
                      deleteAction: {})
    }
}
