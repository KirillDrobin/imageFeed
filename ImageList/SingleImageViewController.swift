import UIKit
final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else {
                return
            }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var singleImageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image else {
            return
        }
        imageView.image = image
        imageView.frame.size = image.size
        
        singleImageScrollView.minimumZoomScale = 0.1
        singleImageScrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
    
    @IBAction private func backward(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let items: [Any] = ["Share a photo"]
        let shareView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(shareView, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
