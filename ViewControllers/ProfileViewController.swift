import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder.jpeg")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private let profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward")!, for: .normal)
        button.addTarget(ProfileViewController.self, action: #selector(didTapExitProfileButton), for: .touchUpInside)
        button.tintColor = .ypRed
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        
        guard let token = oAuth2TokenStorage.token else {
            print("token error ")
            return
        }
        
        DispatchQueue.main.async {
            self.profileService.fetchProfile(token: token) { result in
                self.updateProfileDetails()
                self.profileImageService.fetchProfileImageUrl(token: token) { result in
                    switch result {
                    case .success:
                        print("Success avatar load")
                    case .failure:
                        print("Load avatar error")
                        break
                    }
                }
            }
            
            self.profileImageServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: ProfileImageService.didChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
            self.updateAvatar()
        }
    }
    
    // MARK: - Private Methods
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            nickNameLabel.text = "@\(profile.username)"
            profileDescriptionLabel.text = profile.bio
        } else {
            print("No profile found")
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL
                
        else { return }
        let imageView = profileImageView
        let imageUrl = URL(string: profileImageURL)
        imageView.kf.setImage(with: imageUrl)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl,
                              placeholder: UIImage(named: "placeholder.jpeg"),
                              options: [.processor(processor)]) { result in
            
            switch result {
            case .success(let value):
                print("Kingfisher success")
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
        }
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    }
    
    private func addSubviews() {
        [
            profileImageView,
            nameLabel,
            nickNameLabel,
            profileDescriptionLabel,
            exitButton
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileDescriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapExitProfileButton() {
        
    }
}
