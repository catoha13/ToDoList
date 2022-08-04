import SwiftUI

struct QuickView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.red)
    }
}

struct QuickView_Previews: PreviewProvider {
    static var previews: some View {
        QuickView()
    }
}
