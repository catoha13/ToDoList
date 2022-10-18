import SwiftUI

struct CircleImageView: View {
    @Binding var imageUrl: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl))
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
