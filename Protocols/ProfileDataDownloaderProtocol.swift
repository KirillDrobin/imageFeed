//
//  ProfileAvatarDownloaderProtocol.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 20.09.2024.
//

import UIKit

protocol ProfileDataDownloaderProtocol {
    func updateProfileDetails(nameLabel: UILabel, nickNameLabel: UILabel, profileDescriptionLabel: UILabel)
    func updateAvatar(profileImageView: UIImageView)
}
