
import UIKit
import BFKit
import WebKit
import SwiftyLocalKit

public class ZWebViewController: ZBaseViewController {
    
    private var estimatedProgress: Float = 0.0
    private var currentRequest: URLRequest?
    
    private lazy var wkwebView: WKWebView = {
        let wkConfig = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.minimumFontSize = 20
        preferences.javaScriptCanOpenWindowsAutomatically = true
        wkConfig.preferences = preferences
        let userContentController = WKUserContentController()
        let source = "document.cookie = 'userid=1';"
        let userScript = WKUserScript.init(source: source, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        wkConfig.userContentController = userContentController
        
        let wkView = WKWebView.init(frame: CGRect.init(0, kTopNavHeight + 2, kScreenWidth, kScreenHeight - kTopNavHeight - 2), configuration: wkConfig)
        wkView.uiDelegate = self
        wkView.navigationDelegate = self
        wkView.backgroundColor = ZUIColor.shared.ViewBackgroundColor
        wkView.scrollView.isScrollEnabled = true
        wkView.scrollView.showsVerticalScrollIndicator = true
        wkView.scrollView.showsHorizontalScrollIndicator = false
        wkView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        wkView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        return wkView
    }()
    private lazy var progressView: UIProgressView = {
        let temp = UIProgressView.init(frame: CGRect.init(0, kTopNavHeight, wkwebView.width, 2))
        temp.progressViewStyle = .default
        temp.transform = temp.transform.scaledBy(x: 1, y: 2)
        temp.progressTintColor = "#493443".color
        return temp
    }()
    public var urlString: String? {
        didSet {
            guard let str = self.urlString else { return }
            guard let url = URL.init(string: str)  else { return }
            let req = URLRequest.init(url: url)
            self.wkwebView.load(req)
            self.wkwebView.reload()
        }
    }
    public var pathString: String? {
        didSet {
            guard let path = self.pathString else { return }
            let url = URL.init(fileURLWithPath: path)
            let req = URLRequest.init(url: url)
            self.wkwebView.load(req)
            self.wkwebView.reload()
        }
    }
    public var htmlString: String? {
        didSet {
            guard let html = self.htmlString else { return }
            self.wkwebView.loadHTMLString(html, baseURL: nil)
            self.wkwebView.reload()
        }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.wkwebView)
        self.view.addSubview(progressView)
    }
}
extension ZWebViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    // MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.currentRequest = navigationAction.request
        BFLog.debug("currentRequest: \(navigationAction.request.url?.absoluteString ?? "")")
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        BFLog.debug("didFinish: ")
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            BFLog.debug("document.body.scrollHeight: \(String(describing: result))")
        }
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFail: \(error.localizedDescription)")
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFailProvisionalNavigation: \(error.localizedDescription)")
    }
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    // MARK: - WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        BFLog.debug("body: \(message.body)")
    }
    
    // MARK: - WKUIDelegate
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let itemVC = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: "Continue", style: UIAlertAction.Style.default) { (action) in
            completionHandler()
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC)
    }
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let itemVC = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: "Continue", style: UIAlertAction.Style.default) { (action) in
            completionHandler(true)
        }
        itemVC.addAction(actionDetermine)
        let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default) { (action) in
            completionHandler(false)
        }
        itemVC.addAction(actionCancel)
        ZRouterKit.present(toVC: itemVC)
    }
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let itemVC = UIAlertController.init(title: nil, message: prompt, preferredStyle: UIAlertController.Style.alert)
        itemVC.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        let actionDetermine = UIAlertAction.init(title: "Continue", style: UIAlertAction.Style.default) { (action) in
            completionHandler(itemVC.textFields?.last?.text)
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC)
    }
}
