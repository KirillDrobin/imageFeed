//
//  ProfileAvatarDownloaderService.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 20.09.2024.
//

import UIKit
import Kingfisher

final class ProfileDataDownloaderService: ProfileDataDownloaderProtocol {
  
    private let profileService = ProfileService.shared
    
    func updateProfileDetails(nameLabel: UILabel, nickNameLabel: UILabel, profileDescriptionLabel: UILabel) {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            nickNameLabel.text = "@\(profile.username)"
            profileDescriptionLabel.text = profile.bio
        } else {
            print("No profile found")
        }
    }
    
    func updateAvatar(profileImageView: UIImageView) {
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
