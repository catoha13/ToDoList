import SwiftUI
import CoreData

struct ContentView: View {
    @State var presente = true
    var body: some View {
       LogoView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
