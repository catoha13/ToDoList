import SwiftUI

struct HeaderAndDescription: View {
    @State var text: String
    @State var description: String
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .font(.custom("Roboto-ThinItalic", size: 32)) // add to extension?
                    .padding(.bottom, 10)
                
                Text(description)
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            Spacer()
        }
        .padding(.bottom, 40)
        
    }
}

struct HeaderAndDescription_Previews: PreviewProvider {
    static var previews: some View {
        HeaderAndDescription(text: "Forgot Password",
                             description: "Please enter your email below to recevie your password reset instructions")
    }
}
