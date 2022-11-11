import SwiftUI

struct CircleImageView: View {
    @Binding var image: UIImage?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(uiImage: image ?? UIImage(named: "background")! )
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
            .animation(.default, value: image)
    }
}
