import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController") as! ImageListViewController
        
        imageListViewController.startImageListViewController(ImageListPresenter())
        
        imageListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Main Active"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Profile Active"),
            selectedImage: nil
        )
        profileViewController.startProfileViewController(ProfilePresenter())
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
    
}
