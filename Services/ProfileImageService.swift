import Foundation

struct UserResult: Codable {
    let profileImage: Dictionary<String, String>
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let networkClient = NetworkClient.shared
    private(set) var avatarURL: String?
    private init() {}
    
    func fetchProfileImageUrl(token: String, handler: @escaping (Result<UserResult, any Error>) -> Void) {
        
        guard let userDataRequest = makeUserDataRequest(token: token)
        else {
            print("Avatar URL request error")
            return
        }
        
        networkClient.fetch(request: userDataRequest) { (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let userResult = try decoder.decode(UserResult.self, from: data)
                        let avatarURL = userResult.profileImage["small"]
                        
                        self.avatarURL = avatarURL
                        
                        handler(.success(userResult))
                        
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                userInfo: ["URL": avatarURL ?? "No avatar URL"])
                        
                        print("Success avatar URL load: \(userResult)")
                    } catch {
                        handler(.failure(error))
                        print("Load avatar URL failure")
                    }
                case .failure(let error):
                    print("Avatar error \(error)")
                    handler(.failure(error))
                }
            }
        }
    }
}

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
