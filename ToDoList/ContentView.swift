import SwiftUI
import CoreData

struct ContentView: View {
    @State var presente = true
    var body: some View {
//       LogoView()
        CustomTabBarView(viewRouter: ViewRouter(), isPresented: $presente)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
