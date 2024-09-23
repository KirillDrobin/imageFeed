//
//  ImageListPresenterProtocol.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 22.09.2024.
//
import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    
    func cellDataLoader(cell: ImagesListCell, indexPath: IndexPath)
    func updateTableViewAnimated(for tableView: UITableView)
    func loadImages(for tableView: UITableView)
    func likeChanger(indexPath: IndexPath, cell: ImagesListCell)
}
