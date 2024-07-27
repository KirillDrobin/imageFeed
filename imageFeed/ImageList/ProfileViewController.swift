import UIKit
final class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView()
    
    private let labelName = UILabel()
    
    private let labelNickName = UILabel()
    
    private let labelProfileDescription = UILabel()
    
    private var exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage()
        profileName()
        profileNickName()
        profileDescription()
        exitButtonAction()
    }
    
    
    private func profileImage() {
        let profileImage = UIImage(named: "Photo")
        imageView.image = profileImage
        imageView.tintColor = .gray
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func profileName() {
        labelName.text = "Екатерина Новикова"
        labelName.textColor = .ypWhite
        labelName.font = UIFont.boldSystemFont(ofSize: 23.0)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func profileNickName() {
        labelNickName.text = "@ekaterina_nov"
        labelNickName.textColor = .ypGrey
        labelNickName.font = UIFont.systemFont(ofSize: 13.0)
        labelNickName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelNickName)
        labelNickName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelNickName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
    }
    
    private func profileDescription() {
        labelProfileDescription.text = "Hello, world!"
        labelProfileDescription.textColor = .ypWhite
        labelProfileDescription.font = UIFont.systemFont(ofSize: 13.0)
        labelProfileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelProfileDescription)
        labelProfileDescription.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelProfileDescription.topAnchor.constraint(equalTo: labelNickName.bottomAnchor, constant: 8).isActive = true
    }
    
    private func exitButtonAction() {
        exitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapButton)
        )
        
        exitButton.tintColor = .ypRed
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc private func didTapButton() {
        //        for view in view.subviews {
        //            if view is UILabel {
        //                view.removeFromSuperview()
        //            }
        //        }
    }
    
}
