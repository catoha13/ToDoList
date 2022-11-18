import CoreData
import Foundation

final class UserCoreDataManager {
    private let container = CoreDataManager.shared.container
    private let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
    
    func loadUser() -> ProfileResponseData {
        do {
            let users = try container.viewContext.fetch(fetchRequest)
            return users.first.map { ProfileResponseData(id: $0.id,
                                                         email: $0.email,
                                                         username: $0.username,
                                                         avatarUrl: $0.avatarPath,
                                                         createdAt: $0.createdAt) } ?? ProfileResponseData()
        } catch {
            print("Cannot load the user \(error.localizedDescription)")
            return ProfileResponseData()
        }
    }

    func saveUser(newUser: ProfileResponseData) {
        do {
            let user = Users(context: container.viewContext)
            user.id = newUser.id
            user.username = newUser.username
            user.email = newUser.email
            user.avatarPath = newUser.avatarUrl
            user.createdAt = newUser.createdAt
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Cannot save the user \(error.localizedDescription)")
        }
    }
}
