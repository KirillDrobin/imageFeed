import Foundation

protocol ProfileLoading {
    func fetchProfile(token: String, handler: @escaping (Result<ProfileResult, Error>) -> Void)
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.firstName) + \(String(describing: result.lastName))"
        self.loginName = "@\(result.username)"
        self.bio = result.bio
    }
}

final class ProfileService: ProfileLoading {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private enum CodingKeys : String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    
    private enum ProfileServiceError: Error {
        case profileLoadError
    }
    
    func fetchProfile(token: String, handler: @escaping (Result<ProfileResult, any Error>) -> Void) {
        
        guard let profileDataRequest = makeProfileDataRequest(token: token)
        else {
            print("profileDataRequest error")
            return
        }
        
        networkClient.fetch(request: profileDataRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        handler(.success(profileResult))
                        print("Success profile load: \(profileResult)")
                    } catch {
                        handler(.failure(error))
                    }
                case .failure(let error):
                    print("Fetch profile error \(error)")
                    handler(.failure(error))
                }
            }
        }
    }
}

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
