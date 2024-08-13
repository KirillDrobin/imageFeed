import Foundation
import WebKit

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code)
        else {
            return
        }
        
        let task = URLSession.shared.data(for: tokenRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                    print("Success: \(response.accessToken)")
                } catch {

                    print("Error: \(completion(.failure(error)))")
                    
                    completion(.failure(error))
                }
            case .failure(let error):
                
                print("Error: \(completion(.failure(error)))")
                
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard let baseURL = URL(string: "https://unsplash.com")
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/oauth/token"
        + "?client_id=\(Constants.accessKey)"
        + "&&client_secret=\(Constants.secretKey)"
        + "&&redirect_uri=\(Constants.redirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
}
