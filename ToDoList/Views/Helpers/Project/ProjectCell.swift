import SwiftUI

struct ProjectCell: View {
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.blue)
                        .opacity(0.3)
                    Circle()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 26)
                Spacer()
            }
                Text("Personal")
                    .font(.RobotoThinItalic)
                    .padding(.horizontal,15)
                    .padding(.bottom, 17)
                
                Text("10 Tasks")
                    .font(.RobotoRegular)
                    .foregroundColor(.secondary)
                    .padding(.horizontal,15)
                    .padding(.bottom, 27)
        }
        .frame(width: 165, height: 180)
        
        .background(.white)
    }
}

struct ProjectCell_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCell()
    }
}
