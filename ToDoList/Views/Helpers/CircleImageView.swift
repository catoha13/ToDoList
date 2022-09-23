import SwiftUI

struct CircleImageView: View {
    var image: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
