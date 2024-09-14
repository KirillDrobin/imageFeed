import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    // MARK: - IB Outlets
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet private var gradientView: UIView!
    
    // MARK: - View Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Action
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Methods
    private func gradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.03, 2.8, 1]
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
    }
    
    func setIsLiked(like: Bool) {
        let likeImage = like ? UIImage(named: "Like Active") : UIImage(named: "Like No Active")
        print("Like is \(String(describing: likeImage))")
        likeButton.setImage(likeImage, for: .normal)
    }
}
