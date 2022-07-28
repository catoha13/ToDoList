import SwiftUI

struct Bottom: View {
    var body: some View {
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
    }
}

struct Bottom_Previews: PreviewProvider {
    static var previews: some View {
        Bottom()
    }
}
