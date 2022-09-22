import Foundation
import SwiftUI

final class User {
    @AppStorage("id") var userId: String?
    @AppStorage("email") var savedEmail: String?
    @AppStorage("avatar") var avatar: String?
}
