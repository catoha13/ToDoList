import SwiftUI

struct TopHeader: View {
    @State var text: LocalizedStringKey
    @State private var animated = false
    var body: some View {
        Text(text)
            .font(.RobotoThinItalicHeader)
            .padding(.vertical, 50)
            .offset(y: animated ? 0 : -30)
            .opacity(animated ? 1 : 0)
            .onAppear {
                withAnimation(.default) {
                    animated.toggle()
                }
            }
    }
}
