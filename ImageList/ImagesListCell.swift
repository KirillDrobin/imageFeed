import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient()
    }
    
    private func gradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.03, 2.8, 1]
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
    }
}
