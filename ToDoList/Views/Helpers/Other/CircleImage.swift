import SwiftUI

struct CircleImage: View {
    @Binding var image: UIImage?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image(uiImage: image ?? UIImage(named: "background")! )
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(Circle())
            .animation(.default, value: image)
    }
}
