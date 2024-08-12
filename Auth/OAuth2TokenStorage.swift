import Foundation

final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            let token = storage.string(forKey: Keys.tokenStorage.rawValue)
            return token
        }
        set {
            storage.set(newValue, forKey: Keys.tokenStorage.rawValue)
        }
    }
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case tokenStorage
    }
}
