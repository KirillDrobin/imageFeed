//import Foundation
//
//struct NetworkClient {
//    static let shared = NetworkClient()
//    
//    private enum NetworkError: Error {
//        case codeError
//    }
//    
//    func objectTask<T: Codable>(request: URLRequest, completion: @escaping(Result<T,Error>) -> Void) -> URLSessionTask {
//
//        let decoder: JSONDecoder
//
//        let task = fetch(request: request) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let responseBody = try decoder.decode(T.self, from: data)
//                    completion(.success(responseBody))
//                } catch {
//                    print("")
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                print("\(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }
//        return task
//    }
//    
//    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            if let error = error {
//                handler(.failure(error))
//                return
//            }
//            
//            if let response = response as? HTTPURLResponse,
//               response.statusCode < 200 || response.statusCode >= 300 {
//                handler(.failure(NetworkError.codeError))
//                return
//            }
//            
//            guard var data = data else { return }
//           
//        }
//        task.resume()
//    }
//}
//
//extension URLSession {
//    static let decoder: JSONDecoder = .init()
//}
