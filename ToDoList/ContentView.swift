import SwiftUI
import CoreData

struct ContentView: View {
@State var isPresented = true
    var body: some View {
//       CustomTabBarView(viewRouter: ViewRouter(), isPresented: $isPresented)
        LogoView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
