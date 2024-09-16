import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public Properties
    var fullImageURL: URL?
    
    // MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var singleImageScrollView: UIScrollView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLargePhoto()
    }
    // MARK: - Private Methods
    
    private func downloadLargePhoto() {
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("No large photo")
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        singleImageScrollView.minimumZoomScale = 1.7
        singleImageScrollView.maximumZoomScale = 9
        
        let minZoomScale = singleImageScrollView.minimumZoomScale
        let maxZoomScale = singleImageScrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = singleImageScrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        singleImageScrollView.setZoomScale(scale, animated: false)
        singleImageScrollView.layoutIfNeeded()
        let newContentSize = singleImageScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        singleImageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - IB Action
    @IBAction private func backward(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let items: [Any] = ["Share a photo"]
        let shareView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(shareView, animated: true, completion: nil)
    }
}

// MARK: - extension SingleImageViewController
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
