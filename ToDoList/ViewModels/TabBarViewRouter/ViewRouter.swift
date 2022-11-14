import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .myTask
    
}

enum Page {
    case myTask
    case menu
    case quick
    case profile
}
