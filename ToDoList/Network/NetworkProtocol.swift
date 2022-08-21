import Foundation

protocol NetworkProtocol {
    func get()
    func post<T: Codable, U: Codable>(body: T, url: String, completion: @escaping (Result<U, Error>) -> ())
    func put()
    func delete()
}

extension NetworkProtocol {
    func post<P, M>(body: P, url: String, completion: @escaping (M) -> ()) {}
}
