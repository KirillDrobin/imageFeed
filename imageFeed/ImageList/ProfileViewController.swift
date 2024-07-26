import UIKit
final class ProfileViewController: UIViewController {
    
    @IBAction func exitButtonAction(_ sender: Any) {
    }
    
    @IBOutlet var exitButton: UIButton!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileNickName: UILabel!
    
    @IBOutlet weak var profileDescription: UILabel!
}
