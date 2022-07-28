import SwiftUI

struct CreateTaskView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var assignee = ""
    @State private var project = ""
    @State private var title = "Title"
    @State private var description = ""
    @State private var getDate = "Anytime"
    
    //MARK: Custom back button
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        Image(systemName: "arrow.left")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 25.2, height: 17.71)
            .padding()
    }
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                //MARK: Header
                HStack {
                    Spacer()
                    Text("New Task")
                        .font(Font(Roboto.thinItalic(size: 20)))
                        .foregroundColor(.white)
                        .padding(.top, -24)
                    Spacer()
                }
                .frame(height: 161)
                .background(Color.customCoral)
                
                
                
                //MARK: split into different files
                ZStack {
                    //MARK: Bottom View
                    HStack {
                        Spacer()
                        Text("")
                            .font(Font(Roboto.thinItalic(size: 20)))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        Spacer()
                    }
                    .frame(height: 90)
                    .background(Color.customTabBarColor)
                    .offset(y: 296)
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            //MARK: Assignee
                            Text("For")
                                .font(Font(Roboto.thinItalic(size: 18)))
                            TextField(text: $assignee) {
                                Text("Assignee")
                            }
                            .frame(width: 90, height: 48)
                            .multilineTextAlignment(.center)
                            .background(.bar)
                            .cornerRadius(Constants.raidiusFifty)
                            
                            Spacer()
                            
                            //MARK: Project
                            Text("In")
                                .font(Font(Roboto.thinItalic(size: 18)))
                            TextField(text: $project) {
                                Text("Project")
                            }
                            .frame(width: 90, height: 48)
                            .multilineTextAlignment(.center)
                            .background(.bar)
                            .cornerRadius(Constants.raidiusFifty)
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
                        .background(.bar)
                        
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
                            .background(.bar)
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
                        .background(.bar)
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
                                    .background(.bar)
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
                        CustomFilledButton(text: "Add Task") {
                            
                        }
                    }
                    .frame(width: 343, height: 669)
                    .background(.white)
                    .cornerRadius(Constants.radiusFive)
                    .offset(y: -40)
                    .shadow(radius: 4)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        CreateTaskView()
    }
}
