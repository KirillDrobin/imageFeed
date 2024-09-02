import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        view.backgroundColor = .ypBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oAuth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            switchToAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [logoImageView].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard
            let navigationViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
            let authViewController = navigationViewController.topViewController as? AuthViewController
        else {return}
        
        authViewController.delegate = self
        navigationViewController.modalPresentationStyle = .fullScreen
        present(navigationViewController, animated: true) {
            
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - extension SplashViewController
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oAuth2TokenStorage.token else {
            print("token error ")
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.switchToTabBarController()
                self.profileImageService.fetchProfileImageUrl(token: token) { result in
                    switch result {
                    case .success:
                        print("Success avatar load")
                    case .failure:
                        print("Load avatar error")
                        break
                    }
                }
                print("Success authenticate")
            case .failure:
                print("Load profile error")
                break
            }
        }
    }
}
