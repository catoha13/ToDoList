import SwiftUI

struct StatisticCircle: View {
    @State var persantage = "13%"
    @State var text = "Events"
    @State var color: Color = .customCoral
    @State var progress = 0.25
    var body: some View {
        VStack {
            ZStack {
                Text(persantage)
                Circle()
                    .stroke(.quaternary.opacity(0.4),
                            style: StrokeStyle(lineWidth: 2))
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color,
                            style: StrokeStyle(lineWidth: 2,
                                               lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
            }
            .padding()
            
            Text(text)
                .font(.RobotoMediumSmall)
        }
    }
}

struct StatisticCircle_Previews: PreviewProvider {
    static var previews: some View {
        StatisticCircle()
    }
}
