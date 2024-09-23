//
//  ProfileViewControllerProtocol.swift
//  imageFeedTests
//
//  Created by Кирилл Дробин on 22.09.2024.
//
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var profileImageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var nickNameLabel: UILabel { get set }
    var profileDescriptionLabel: UILabel { get set }
    func addSubviews()
    func makeConstraints()
}
