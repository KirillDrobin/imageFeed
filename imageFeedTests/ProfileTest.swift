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
    var viewDidLoadCalled: Bool = false
    
    func updateProfile() {
        updateProfileCalled = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profileImageView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var nickNameLabel: UILabel = UILabel()
    var profileDescriptionLabel: UILabel = UILabel()
    
    var addSubviewsCalled: Bool = false
    var makeConstraintsCalled: Bool = false
    
    func addSubviews() {
        addSubviewsCalled = true
    }
    
    func makeConstraints() {
        makeConstraintsCalled = true
    }
}

final class ProfileTests: XCTestCase {
        
    func testViewControllerCallsUpdateProfile() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.updateProfileCalled) //behaviour verification
    }
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerCallsMakeConstraints() {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewControllerSpy()
       
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.makeConstraintsCalled) //behaviour verification
    }
    
    func testPresenterCallsAddSubviews() {
        //given
        let presenter = ProfilePresenter()
        let viewController = ProfileViewControllerSpy()
       
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.addSubviewsCalled) //behaviour verification
    }
    
}
