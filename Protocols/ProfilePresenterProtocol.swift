//
//  File.swift
//  imageFeedTests
//
//  Created by Кирилл Дробин on 22.09.2024.
//
import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfile()
    func updateProfileDetails(nameLabel: UILabel, nickNameLabel: UILabel, profileDescriptionLabel: UILabel)
    func updateAvatar(profileImageView: UIImageView)
}
