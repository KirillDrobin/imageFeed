import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    // MARK: - Private Properties
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    @IBOutlet weak private var loginButton: UIButton!
    
    // MARK: - Public Properties
    var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - extension AuthViewController
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code: code) { [self] result in
            switch result {
            case .success(let token):
                oAuth2TokenStorage.token = token
                delegate?.didAuthenticate(self)
            case .failure(_):
                let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
                present(alert, animated: true)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: false)
                }))
                present(alert, animated: true)
                print("Authorization error")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
