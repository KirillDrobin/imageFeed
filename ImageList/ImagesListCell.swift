import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
        
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    private func gradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.03, 2.8, 1]
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
    }
    
    func setIsLiked(like: Bool) {
        var likeImage = UIImage()
        if like == true {
            likeImage = UIImage(named: "Like Active") ?? UIImage()
        } else {
            likeImage = UIImage(named: "Like No Active") ?? UIImage()
        }
        
        likeButton.setImage(likeImage, for: .normal)
    }
}
