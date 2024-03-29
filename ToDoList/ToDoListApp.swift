import SwiftUI

@main
struct ToDoListApp: App {
    
    @State var isPresented = true
    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
             LogoView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
