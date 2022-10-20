import SwiftUI

struct CompleteTask: View {
    //MARK: Assigned
    @State var title = "Meeting according with design team in Central Park"
    @State var image = "superhero"
    @State var username = "Stephen Chow"
    //MARK: Due
    @State var dueDate = "Aug 4, 2020"
    @State var description = "Lorem ipsum dolor sit amet, consectetur adipiscing. "
    //MARK: Tag
    @State var tag = "Personal"
    @State var color: Color = .customBlue
    //MARK: comment
    @State private var showComments = false
    @Binding var showSideView: Bool
    @Binding var closeViewTask: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                //MARK: Buttons
                HStack {
                    Button {
                        closeViewTask.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .rotationEffect(Angle(degrees: 45))
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button {
                        showSideView.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .rotationEffect(Angle(degrees: 45))
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                //MARK: Title
                Text(title)
                    .font(Font(Roboto.thinItalic(size: 18)))
                
                //MARK: Assigned to
                VStack {
                    HStack {
                        Image(image)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Assigned to")
                                .font(Font(Roboto.regular(size: 16)))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 01)
                            Text(username)
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
                            Text(dueDate)
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
                                Image(image)
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                Image(image)
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
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
        .frame(width: 343, height: 716)
        .background(.white)
        .cornerRadius(Constants.radiusFive)

    }
}

struct CompleteTask_Previews: PreviewProvider {
    @State static var showSideView = false
    @State static var closeViewTask = false
    static var previews: some View {
        CompleteTask(showSideView: $showSideView, closeViewTask: $closeViewTask)
    }
}
