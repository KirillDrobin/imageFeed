//
//  ProfileAvatarDownloaderService.swift
//  imageFeed
//
//  Created by Кирилл Дробин on 20.09.2024.
//

import UIKit
import Kingfisher

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?

    var photos: [Photo] = []
    private let imageListDateFormatterService = ImageListDateFormatterService()
    private let imagesListService = ImagesListService.shared
    
    func cellDataLoader(cell: ImagesListCell, indexPath: IndexPath) {
        let imageURL = URL(string: photos[indexPath.row].thumbImageURL)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        cell.cellImage.kf.setImage(with: imageURL,
                                   placeholder: UIImage(named: "Rectangle 169"),
                                   options: [.processor(processor)])
        
        guard let date = photos[indexPath.row].createdAt else { return }
        
        cell.setIsLiked(like: photos[indexPath.row].isLiked)
        cell.dateLabel.text = imageListDateFormatterService.dateFormatter.string(from: date)
    }
    
    func updateTableViewAnimated(for tableView: UITableView) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let oldCount = photos.count
            let newCount = imagesListService.photos.count
            photos = imagesListService.photos
            if oldCount != newCount {
                tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
    
    func loadImages(for tableView: UITableView) {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            switch result {
            case .success:
                self?.updateTableViewAnimated(for: tableView)
            case .failure:
                print("")
            }
        }
    }
    
    func likeChanger(indexPath: IndexPath, cell: ImagesListCell) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(like: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                print("Change like ok")
            case .failure:
                print("No like change")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

