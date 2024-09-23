import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol{
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle 169")
        imageView.frame.size.width = 70
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    var profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(didTapExitProfileButton), for: .touchUpInside)
        button.tintColor = .ypRed
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        exitButton.accessibilityIdentifier = "logout button"
        UIBlockingProgressHUD.show()
        view.backgroundColor = .ypBlack
        presenter?.viewDidLoad()
        presenter?.updateProfile()
    }
    
    // MARK: - Init
    func startProfileViewController(_ presenter: ProfilePresenterProtocol) {
        self.presenter = ProfilePresenter()
        self.presenter?.view = self
    }
    
    // MARK: - Methods
    func addSubviews() {
        [
            profileImageView,
            nameLabel,
            nickNameLabel,
            profileDescriptionLabel,
            exitButton,
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    func makeConstraints() {
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
        let alert = UIAlertController(title: "Пока-пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let alertYes = UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            self?.profileLogoutService.logout()
        })
        let alertNo = UIAlertAction(title: "Нет", style: .default, handler: { action in
            alert.dismiss(animated: true)
        })
        alert.addAction(alertYes)
        alert.addAction(alertNo)
        alert.preferredAction = alertNo
        present(alert, animated: true)
    }
}
