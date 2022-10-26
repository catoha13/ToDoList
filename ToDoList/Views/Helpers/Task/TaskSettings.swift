import SwiftUI

struct TaskSettings: View {
    @Binding var isPresented: Bool
    
    @State var addMemberAction: () -> ()
    @State var editAction: () -> ()
    @State var deleteAction: () -> ()
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    //MARK: Add member
                    Button(action: {
                        withAnimation(.default) {
                            addMemberAction()
                        }
                    }, label: {
                        HStack {
                            Text("Add member")
                            Spacer()
                        }
                    })
                    .padding(.leading)
                    .padding(.vertical, 10)

                    //MARK: Edit task
                    Button(action: {
                        withAnimation(.default) {
                            addMemberAction()
                        }
                    }, label: {
                        HStack {
                            Text("Edit task")
                            Spacer()
                        }
                    })
                    .padding(.leading)
                    .padding(.vertical, 10)

                    //MARK: Delete task
                    Button(action: {
                        withAnimation(.default) {
                            addMemberAction()
                        }
                    }, label: {
                        HStack {
                            Text("Delete task")
                            Spacer()
                        }
                    })
                    .padding(.leading)
                    .padding(.vertical, 10)

                }
                .font(.RobotoThinItalicSmall)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
                .padding(.bottom, 400)
                .frame(width: 228, height: 130)
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            withAnimation(.default) {
                isPresented.toggle()
            }
        }
    }
}

struct TaskSettings_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        TaskSettings(isPresented: $isPresented,
                     addMemberAction: {},
                     editAction: {},
                     deleteAction: {})
    }
}
