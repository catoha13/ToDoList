import SwiftUI

struct CommentsView: View {
    @State var text = ""
    
    var body: some View {
        VStack {
            VStack {
                TextField(text: $text) {
                    Text("Text here")
                        .font(Font(Roboto.regular(size: 16)))
                        
                }
                .padding(.horizontal, 10)
                Spacer()
                HStack {
                    //MARK: Attachments
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .frame(width: 19.61, height: 20.54)
                            .foregroundColor(.secondary)
                            .padding(.all, 10)
                            .padding(.leading, 2)
                        
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "paperclip")
                            .resizable()
                            .frame(width: 19.61, height: 20.54)
                            .foregroundColor(.secondary)
                            .padding(.all, 10)
                        
                    }
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Send")
                            .padding(.trailing)
                            .font(Font(Roboto.thinItalic(size: 16)))
                    }
                }
                .background(.quaternary)
            }
            .frame(width: 295, height: 120)
            .overlay(RoundedRectangle(cornerRadius: Constants.radiusFive)
            .stroke(lineWidth: 1)
            .foregroundColor(.customGray))
            .cornerRadius(Constants.radiusFive)
            
            
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
