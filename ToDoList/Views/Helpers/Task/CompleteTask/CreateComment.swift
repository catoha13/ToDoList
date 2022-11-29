import SwiftUI

struct CreateComment: View {
    @Binding var text: String
    
    @State var createAction: () -> ()
    
    var body: some View {
        VStack {
            VStack {
                TextEditor(text: $text)
                    .font(Font(Roboto.regular(size: 16)))
                    .padding(.horizontal, 10)
                Spacer()
                HStack {
                    //MARK: Attachments
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.secondary)
                            .padding(.all, 10)
                            .padding(.leading, 2)
                        
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "paperclip")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.secondary)
                            .padding(.all, 10)
                        
                    }
                    Spacer()
                    
                    Button {
                        createAction()
                    } label: {
                        Text("Send")
                            .padding(.trailing)
                            .font(Font(Roboto.thinItalic(size: 16)))
                    }
                }
                .background(Color.customBar)
            }
            .frame(width: 295, height: 120)
            .overlay(RoundedRectangle(cornerRadius: Constants.radiusFive)
                .stroke(lineWidth: 1)
                .foregroundColor(.customGray))
            .cornerRadius(Constants.radiusFive)
            
            
        }
    }
}

struct CreateComment_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        CreateComment(text: $text, createAction: {})
    }
}
