import Foundation

final class SignInService: NetworkProtocol {
    
    func post<T, M>(body: T, url: String, completion: @escaping (Result<M, Error>) -> ()) where T : Encodable, M : Decodable {
        
        NetworkMaganer.shared.post(body: body, url: url) { (_ response: Result<SignInResponseModel, Error>) in
            switch response {
            case .success(let response):
                completion(.success(response as! M))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

   
    func get() {}
    func put() {}
    func delete() {}
}
