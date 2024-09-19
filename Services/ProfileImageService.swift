import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    private init() {}
    
    // MARK: - fetchProfileImageUrl func
    func fetchProfileImageUrl(token: String, handler: @escaping (Result<UserResult, any Error>) -> Void) {
        
        guard let userDataRequest = makeUserDataRequest(token: token),
              task == nil
        else {
            print("Avatar URL request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: userDataRequest) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let data):
                let avatarURL = data.profileImage["small"]
                
                self.avatarURL = avatarURL
                
                handler(.success(data))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL ?? "No avatar URL"])
                
            case .failure(let error):
                print("Avatar URL load error")
                handler(.failure(error))
            }
            
        }
        self.task = task
        task.resume()
    }
}

// MARK: - makeUserDataRequest private func
private func makeUserDataRequest(token: String) -> URLRequest? {
    let profileService = ProfileService.shared
    guard let profile = profileService.profile else {
        print("Empty username")
        return nil
    }
    let username = profile.username
    
    guard let baseURL = Constants.defaultBaseURL
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/users/\(username)",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    print("Avatar URL Request: \(request)")
    return request
}

// MARK: - Models
struct UserResult: Codable {
    let profileImage: Dictionary<String, String>
}
