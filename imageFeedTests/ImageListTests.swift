//
//  File.swift
//  imageFeedTests
//
//  Created by Кирилл Дробин on 22.09.2024.
//

@testable import imageFeed
import XCTest

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol?
    var cellDataLoaderCalled: Bool = false
    var loadImagesCalled: Bool = false
    var updateTableViewAnimatedCalled: Bool = false
    var photos: [imageFeed.Photo] = []
    
    func cellDataLoader(cell: imageFeed.ImagesListCell, indexPath: IndexPath) {
        cellDataLoaderCalled = true
    }
    
    func updateTableViewAnimated(for tableView: UITableView) {
        updateTableViewAnimatedCalled = true
    }
    
    func loadImages(for tableView: UITableView) {
        loadImagesCalled = true
    }
    
    func likeChanger(indexPath: IndexPath, cell: imageFeed.ImagesListCell) {
        
    }
}

final class ImageListTests: XCTestCase {
    
    func testViewControllerCallsLoadImages() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
        let presenter = ImageListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.loadImagesCalled) //behaviour verification
    }
}
