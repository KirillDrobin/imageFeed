import Foundation

final class ProfileService {
    // MARK: - Static Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    private init() {}
    
    private enum ProfileServiceError: Error {
        case profileLoadError
    }
    
    // MARK: - fetchProfile func
    func fetchProfile(token: String, handler: @escaping (Result<ProfileResult, any Error>) -> Void) {
        
        guard let profileDataRequest = makeProfileDataRequest(token: token),
              task == nil
        else {
            print("profileDataRequest error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: profileDataRequest) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let data):
                let profile = Profile(
                    username: data.username,
                    name: [data.firstName, data.lastName ?? ""].joined(separator: " "),
                    bio: data.bio
                )
                self.profile = profile
                handler(.success(data))
            case .failure(let error):
                print("Load profile data error")
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }   
}

// MARK: - makeProfileDataRequest private func
private func makeProfileDataRequest(token: String) -> URLRequest? {
    guard let baseURL = Constants.defaultBaseURL
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/me",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    print("URL Request: \(request)")
    return request
}

// MARK: - Models
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let bio: String?
}

