//
//  File.swift
//  imageFeedTests
//
//  Created by Кирилл Дробин on 22.09.2024.
//
@testable import imageFeed
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var updateProfileCalled: Bool = false
    
    func updateProfile() {
        updateProfileCalled = true
    }
    
    func updateProfileDetails(nameLabel: UILabel, nickNameLabel: UILabel, profileDescriptionLabel: UILabel) {
        
    }
    
    func updateAvatar(profileImageView: UIImageView) {
        
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var profileImageView: UIImageView = UIImageView()
    
    var nameLabel: UILabel = UILabel()
    
    var nickNameLabel: UILabel = UILabel()
    
    var profileDescriptionLabel: UILabel = UILabel()
}

final class ProfileTests: XCTestCase {
        
    func testViewControllerCallscellDataLoader() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.updateProfileCalled) //behaviour verification
    }
}
