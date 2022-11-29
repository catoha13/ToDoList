import SwiftUI

struct TaskFilterSettings: View {
    @Binding var isPresented: Bool
    @Binding var isSelected: Int
    
    @State var showIncpomlete: () -> ()
    @State var showComplete: () -> ()
    @State var showAll: () -> ()
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        //MARK: Show Incomplete tasks
                        Button(action: {
                            withAnimation(.default) {
                                isSelected = 0
                                showIncpomlete()
                            }
                        }, label: {
                            HStack {
                                Text("Incomplete Tasks")
                                Spacer()
                            }
                        })
                        .padding(.leading)
                        .padding(.vertical, 10)
                        
                        if isSelected == 0 {
                            Image("check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(.trailing)
                        }
                    }
                    
                    //MARK: Show Complete tasks
                    HStack {
                        Button(action: {
                            withAnimation(.default) {
                                isSelected = 1
                                showComplete()
                            }
                        }, label: {
                            HStack {
                                Text("Completed Tasks")
                                Spacer()
                            }
                        })
                        .padding(.leading)
                        .padding(.vertical, 10)
                        
                        if isSelected == 1 {
                            Image("check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(.trailing)
                        }
                    }
                    
                    //MARK: Show all
                    HStack {
                        Button(action: {
                            withAnimation(.default) {
                                isSelected = 2
                                showAll()
                            }
                        }, label: {
                            HStack {
                                Text("All Tasks")
                                Spacer()
                            }
                        })
                        .padding(.leading)
                        .padding(.vertical, 10)
                        
                        if isSelected == 2 {
                            Image("check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(.trailing)
                        }
                        
                    }
                    
                }
                .font(.RobotoThinItalicSmall)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(Constants.radiusFive)
                .padding(.bottom, 400)
                .padding(.trailing)
                .frame(width: 268, height: 130)
            }
        }
        .onTapGesture {
            isPresented.toggle()
        }
    }
}

struct TaskFilterSettings_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var isSelected = 0
    static var previews: some View {
        TaskFilterSettings(isPresented: $isPresented,
                           isSelected: $isSelected,
                           showIncpomlete: {},
                           showComplete: {},
                           showAll: {})
    }
}
