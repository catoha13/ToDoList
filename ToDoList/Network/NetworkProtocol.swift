import Foundation
import Combine

protocol NetworkProtocol {
    func get<U: Decodable>(path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func post<T: Codable, U: Codable>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func put()
    func delete()
}
