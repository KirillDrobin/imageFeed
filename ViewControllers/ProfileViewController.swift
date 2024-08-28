import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Photo")
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
    
    private var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward")!, for: .normal)
        button.addTarget(ProfileViewController.self, action: #selector(didTapExitProfileButton), for: .touchUpInside)
        button.tintColor = .ypRed
        return button
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        
        guard let token = oAuth2TokenStorage.token else {
            print("token error ")
            return
        }
        
        profileService.fetchProfile(token: token) { result in
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
        
        profileImageServiceObserver = NotificationCenter.default    // 2
                   .addObserver(
                       forName: ProfileImageService.didChangeNotification, // 3
                       object: nil,                                        // 4
                       queue: .main                                        // 5
                   ) { [weak self] _ in
                       guard let self = self else { return }
                       self.updateAvatar()                                 // 6
                   }
               updateAvatar()

    }
    
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            nickNameLabel.text = "@\(profile.username)"
            profileDescriptionLabel.text = profile.bio
        } else {
            print("No profile found")
        }
    }
    
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO [Sprint 11] Обновить аватар, используя Kingfisher
    }
    
    private func addSubviews() {
        [
            profileImageView,
            nameLabel,
            nickNameLabel,
            profileDescriptionLabel,
            exitButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
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
