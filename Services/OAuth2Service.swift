import Foundation
import WebKit
import ProgressHUD

enum AuthServiceError: Error {
    case invalidRequest
}

struct OAuthTokenResponseBody: Codable {
    var accessToken: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code)
        else {
            return
        }
        
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        let task = URLSession.shared.data(for: tokenRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        UIBlockingProgressHUD.dismiss()
                        
                        self.task = nil
                        self.lastCode = nil
                    
                        print("Success token: \(response.accessToken)")
                        completion(.success(response.accessToken))
                    } catch {
                        
                        print("Error token: \(completion(.failure(error)))")
                        
                        completion(.failure(error))
                    }
                case .failure(let error):
                    
                    print("Error: \(completion(.failure(error)))")
                    
                    completion(.failure(error))
                }
            }
        }
        self.task = task
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
    print("Token request: \(request)")
    return request
}
