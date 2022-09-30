import Foundation
import SwiftUI
import Combine

protocol NetworkProtocol {
    func get<U: Decodable>(path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func post<T: Codable, U: Codable>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func put<T: Codable, U: Decodable>(body: T, path: String, header: String) -> AnyPublisher<U, NetworkError>
    func delete<U: Decodable>(path: String, header: String) -> AnyPublisher<U, NetworkError>
    func uploadAvatar<U: Decodable>(path: String, header: String, image: UIImage? ,parameters: [String: Any]) -> AnyPublisher<U, NetworkError>
}
