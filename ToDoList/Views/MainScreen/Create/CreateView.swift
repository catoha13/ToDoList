import SwiftUI

struct CreateView: View {
    @Binding var isPresented: Bool
    @State var showQuickNote = false
    @State var showCreateTask = false
    var body: some View {
        
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: 20)
                .background(showCreateTask || showQuickNote ? .clear : .secondary)
                .onTapGesture {
                    if showQuickNote == true || showCreateTask == false {
                        isPresented.toggle()
                    }
                }
            
            VStack {
                Button {
                    withAnimation {
                        showCreateTask.toggle()
                    }
                } label: {
                    Label {
                        Text("Add Task")
                            .font(Font(Roboto.thinItalic(size: 18)))
                            .foregroundColor(.customBlack)
                    } icon: {}
                        .padding()
                        .frame(width: 220)
                }
                Divider()
                
                Button {
                    withAnimation {
                        showQuickNote.toggle()
                    }
                } label: {
                    Label {
                        Text("Add Quick Note")
                            .font(Font(Roboto.thinItalic(size: 18)))
                            .foregroundColor(.customBlack)
                    } icon: {}
                        .padding()
                        .frame(width: 220)
                }
                Divider()
                
                Button {
                    
                } label: {
                    Label {
                        Text("Add Check List")
                            .font(Font(Roboto.thinItalic(size: 18)))
                            .foregroundColor(.customBlack)
                    } icon: {}
                        .padding()
                        .frame(width: 220)
                }
            }
            .frame(width: 268, height: 214)
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            
            //MARK: Show Create Task
            if showCreateTask {
                CreateTaskView(isPresented: $showCreateTask)
            }
            //MARK: Show Quick Note
            if showQuickNote {
                CreateNoteView(isPresented: $showQuickNote)
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        CreateView(isPresented: $isPresented)
            .cornerRadius(Constants.radiusFive)
    }
}
