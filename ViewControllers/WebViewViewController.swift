import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol{
    
    // MARK: - Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    // MARK: - IB Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        webView.accessibilityIdentifier = "UnsplashWebView"
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Public Methods
    func load(request: URLRequest) {
        webView.load(request)
    }

    // MARK: - Methods
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(WebViewViewController())
    }
}

// MARK: - extension WebViewViewController
extension WebViewViewController: WKNavigationDelegate {
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
}
