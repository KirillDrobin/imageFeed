import UIKit
//import Kingfisher

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    // MARK: - Properties
    var presenter: ImageListPresenterProtocol?
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var ImagesListViewControllerObserver: NSObjectProtocol?
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        ImagesListViewControllerObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateTableViewAnimated(for: tableView)
            }
        presenter?.loadImages(for: tableView)
        UIBlockingProgressHUD.show()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let largeImageURL = presenter?.photos[indexPath.row].largeImageURL else { return }
            guard let fullImageURL = URL(string: largeImageURL) else { return }
            
            viewController.fullImageURL = fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
            
        }
    }
    
    func startImageListViewController(_ presenter: ImageListPresenterProtocol) {
        self.presenter = ImageListPresenter()
        self.presenter?.view = self
    }
}

// MARK: - extensions ImagesListViewController
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(cell: imageListCell, indexPath: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        if indexPath.row == ((presenter?.photos.count ?? 1) - 1) {
            presenter?.loadImages(for: tableView)
        }
    }
}

extension ImageListViewController {
    // MARK: - Private Methods
    private func configCell(cell: ImagesListCell, indexPath: IndexPath) {
        presenter?.cellDataLoader(cell: cell, indexPath: indexPath)
        cell.delegate = self
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, cell: ImagesListCell) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        var imageWidth = presenter?.photos[indexPath.row].size.width
        if imageWidth == 0 {
            imageWidth = 200
            print("Attention, imageWidth in imageListViewController == 0!")
        }
        
        let scale = imageViewWidth / (imageWidth ?? CGFloat(1))
        let cellHeight = (presenter?.photos[indexPath.row].size.height ?? CGFloat(1)) * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell)
        else {
            return }
        presenter?.likeChanger(indexPath: indexPath, cell: cell)
    }
}
