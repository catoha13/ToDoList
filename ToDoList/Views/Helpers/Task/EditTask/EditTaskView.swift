import SwiftUI

struct EditTaskView: View {
    @Binding var isPresented: Bool
    
    @Binding var title: String
    @Binding var members: [Members]?
    @Binding var membersAvatars: [UIImage]
    @Binding var dueDate: String
    @Binding var description: String
    
    @State var tag = "Personal"
    @State var color: Color = .customBlue
    
    @State var updateAction: () -> ()
    
    @State private var showComments = false
    
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
                        Text("Task Edit")
                            .font(.RobotoThinItalicSmall)
                            .padding(.trailing, 22)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    //MARK: Title
                    HStack {
                        TextField("Enter new title", text: $title)
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
                    .padding(.vertical, -5)
                    
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
                                TextField("Enter description", text: $description)
                                    .font(Font(Roboto.regular(size: 16)))
                                    .lineLimit(2)
                                    .padding(.trailing, 10)
                                Spacer()
                            }
                            Spacer()
                        }
                        Divider()
                            .frame(width: 295)
                            .padding(.vertical, -10)
                            .padding(.leading, -10)
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

                    CustomBlueFilledButton(text: "Done") {
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

struct EditTaskView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var taskTitle = ""
    @State static var taskId = ""
    @State static var dueDate = ""
    @State static var description = ""
    @State static var assigned_to = ""
    @State static var projectId = ""
    @State static var members: [Members]? = []
    
    @State static var membersUrls: [String] = []
    @State static var membersAvatars: [UIImage] = []
    
    static var previews: some View {
        EditTaskView(isPresented: $isPresented,
                     title: $taskTitle,
                     members: $members,
                     membersAvatars: $membersAvatars,
                     dueDate: $dueDate,
                     description: $description,
                     updateAction: {})
    }
}
