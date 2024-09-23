//
//  File.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 22.09.2024.
//

import UIKit
import Kingfisher

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    func viewDidLoad() {
        view?.addSubviews()
        view?.makeConstraints()
    }
    
    func updateProfile() {
        guard let token = oAuth2TokenStorage.token
        else {
            print("token error ")
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.profileService.fetchProfile(token: token) { [weak self] result in
                guard let self = self else { return }
                self.updateProfileDetails(nameLabel: view?.nameLabel ?? UILabel(),
                                          nickNameLabel: view?.nickNameLabel ?? UILabel(),
                                          profileDescriptionLabel: view?.profileDescriptionLabel ?? UILabel())
                
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
            
            self?.profileImageServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: ProfileImageService.didChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar(profileImageView: view?.profileImageView ?? UIImageView())
                }
            guard let self = self else { return }
            self.updateAvatar(profileImageView: view?.profileImageView ?? UIImageView())
        }
    }
    
    private func updateProfileDetails(nameLabel: UILabel, nickNameLabel: UILabel, profileDescriptionLabel: UILabel) {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            nickNameLabel.text = "@\(profile.username)"
            profileDescriptionLabel.text = profile.bio
        } else {
            print("No profile found")
        }
    }
    
    private func updateAvatar(profileImageView: UIImageView) {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else { return }
        let imageView = profileImageView
        let imageUrl = URL(string: profileImageURL)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Rectangle 169")) { result in
            switch result {
            case .success(let value):
                print("Kingfisher avatar success")
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
        }
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
    }
}
