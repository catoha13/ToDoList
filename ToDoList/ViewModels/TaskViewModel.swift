import Combine
import SwiftUI

final class TaskViewModel: ObservableObject {
    
    @Published var selected = 0
    
    private var token = Token()
    private let user = User()
    private var taskService = TaskNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private var header: String {
      return (token.tokenType ?? "") + " " + (token.savedToken ?? "")
    }
    private var ownerId: String {
        return user.userId ?? "no data"
    }
}
