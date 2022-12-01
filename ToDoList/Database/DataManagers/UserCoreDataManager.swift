import CoreData
import Foundation

struct UserCoreDataManager {
    private let savedUser = User()
    private let context = CoreDataManager.shared.container
    private let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
    
    func loadUser() -> ProfileResponseData {
        do {
            let users = try context.viewContext.fetch(fetchRequest)
            let user = users.first(where: { $0.id == savedUser.id })
            return user.map { ProfileResponseData(id: $0.id,
                                                         email: $0.email,
                                                         username: $0.username,
                                                         avatarUrl: $0.avatarPath,
                                                         createdAt: $0.createdAt
            )} ?? ProfileResponseData()
        } catch {
            print("Cannot load the user \(error.localizedDescription)")
            return ProfileResponseData()
        }
    }
    
    func saveUser(newUser: ProfileResponseData) {
        do {
            let user = Users(context: context.viewContext)
            user.id = newUser.id ?? ""
            user.username = newUser.username
            user.email = newUser.email
            user.avatarPath = newUser.avatarUrl
            user.createdAt = newUser.createdAt
            
            if context.viewContext.hasChanges {
                try context.viewContext.save()
            }
        } catch {
            print("Cannot save the user \(error.localizedDescription)")
        }
    }
}
