import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys : String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let name: String
    let bio: String?
}

final class ProfileService {
    
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private var lastToken: String?
    private let networkClient = NetworkClient.shared
    
    private(set) var profile: Profile?
    init() {}
    
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
                        
                        let profile = Profile(
                            username: profileResult.username,
                            name: [profileResult.firstName, profileResult.lastName ?? ""].joined(separator: " "),
                            bio: profileResult.bio
                        )
                        self.profile = profile
                        
                        handler(.success(profileResult))
                        print("Success profile load: \(profileResult)")
                    } catch {
                        handler(.failure(error))
                        print("failure")
                    }
                case .failure(let error):
                    print("Fetch profile error \(error)")
                    handler(.failure(error))
                }
            }
        }
        //        networkClient.fetch(request: profileDataRequest) { result in
        //            DispatchQueue.main.async {
        //                switch result {
        //                case .success(let data):
        //                    do {
        //                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
        //
        //                        let profile = Profile(
        //                            username: profileResult.username,
        //                            name: [profileResult.firstName, profileResult.lastName ?? ""].joined(separator: " "),
        //                            bio: profileResult.bio
        //                        )
        //                        self.profile = profile
        //
        //                        handler(.success(profileResult))
        //                        print("Success profile load: \(profileResult)")
        //                    } catch {
        //                        handler(.failure(error))
        //                        print("failure")
        //                    }
        //                case .failure(let error):
        //                    print("Fetch profile error \(error)")
        //                    handler(.failure(error))
        //                }
        //            }
        //        }
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


