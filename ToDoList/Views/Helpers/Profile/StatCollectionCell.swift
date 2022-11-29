import SwiftUI

struct StatCollectionCell: View {
    @State var text: LocalizedStringKey = "Events"
    @Binding var count: Int
    @State var backgroundColor: Color = Color.customBlue
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(text)
                    .font(.RobotoThinItalicSmall)
                    .padding(.bottom, 7)
                Text("\(count) Tasks")
                    .font(.RobotoMediumSmall)
                Spacer()
            }
            .padding(.leading, 24)
            Spacer()
        }
        .foregroundColor(.white)
        .background(backgroundColor)
        .frame(width: 160, height: 100)
        .cornerRadius(Constants.radiusFive)
    }
}

struct StatCollectionCell_Previews: PreviewProvider {
    @State static var count = 0
    static var previews: some View {
        StatCollectionCell(count: $count)
    }
}
