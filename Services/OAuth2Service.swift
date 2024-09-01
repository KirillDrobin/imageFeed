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
    
    func fetchOAuthToken(code: String, handler: @escaping (_ result: Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code)
        else {
            return
        }
        
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        let task = URLSession.shared.objectTask(for: tokenRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { preconditionFailure("") }
            self.task = nil
            self.lastCode = nil
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                print("Success token: \(data.accessToken)")
                handler(.success(data.accessToken))
            case .failure(let error):
                print("Error: \(handler(.failure(error)))")
                handler(.failure(error))
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
        string: "/oauth/token" // MARK: удалить 1
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
