import Foundation
import Combine

protocol NetworkProtocol {
    func get<T: Encodable, U: Decodable>(body: T?, path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func post<T: Encodable, U: Decodable>(body: T, path: String, header: String?) -> AnyPublisher<U, NetworkError>
    func put<T: Encodable, U: Decodable>(body: T, path: String, header: String) -> AnyPublisher<U, NetworkError>
    func delete<U: Decodable>(path: String, header: String) -> AnyPublisher<U, NetworkError>
}
