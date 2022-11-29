import SwiftUI

struct StatisticCircle: View {
    @Binding var percentage: String
    @State var text: LocalizedStringKey = "Events"
    @State var color: Color = .customCoral
    @Binding var progress: Double
    var body: some View {
        VStack {
            ZStack {
                Text(percentage)
                Circle()
                    .stroke(.quaternary.opacity(0.4),
                            style: StrokeStyle(lineWidth: 4))
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color.opacity(0.75),
                            style: StrokeStyle(lineWidth: 6,
                                               lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
            }
            .padding()
            
            Text(text)
                .font(.RobotoMediumSmall)
        }
        .animation(.default, value: progress)
    }
}

struct StatisticCircle_Previews: PreviewProvider {
    @State static var percentage = "99%"
    @State static var progress = 5.0
    static var previews: some View {
        StatisticCircle(percentage: $percentage, progress: $progress)
    }
}
