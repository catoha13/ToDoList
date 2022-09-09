import Foundation
import Combine

protocol NetworkProtocol {
    func get()
    func post<T: Codable, U: Codable>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func put()
    func delete()
}
