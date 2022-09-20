import SwiftUI

struct StatisticCollection: View {
    @State var tasksCount = 0
    @State var toDoCount = 0
    @State var eventsCount = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                StatCollectionCell(text: "Events",
                                   count: eventsCount,
                                   backgroundColor: .customCoral)
                StatCollectionCell(text: "To do Task",
                                   count: toDoCount,
                                   backgroundColor: .customBlue)
                StatCollectionCell(text: "Tasks", count: tasksCount, backgroundColor: .customPurple)
            }
        }
        .padding(.horizontal, 8)
    }
}

struct StatisticCollection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticCollection()
    }
}
