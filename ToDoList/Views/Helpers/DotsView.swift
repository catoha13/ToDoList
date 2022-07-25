import SwiftUI

struct DotsView: View {
    @State var firstColor: Bool
    @State var secondColor: Bool
    @State var thirdColor: Bool
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 8, height: 8)
            
            Circle()
                .frame(width: 8, height: 8)
            
            Circle()
                .frame(width: 8, height: 8)
        }
        .padding()
    }
}

struct DotsView_Previews: PreviewProvider {
    
    static var previews: some View {
        DotsView(firstColor: true, secondColor: false, thirdColor: false)
            .previewLayout(.fixed(width: 100, height: 20))
    }
}
