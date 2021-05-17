
import UIKit
import BFKit
import WebKit
import SwiftyLocalKit

class ZHtmlViewController: ZBaseViewController {
    
    public var filePath: String = "" {
        didSet {
            do {
                self.textContent.text = try String.init(contentsOfFile: filePath)
            } catch {
                BFLog.debug("\(error.localizedDescription)")
            }
        }
    }
    private lazy var textContent: UITextView = {
        let item = UITextView.init(frame: CGRect.init(x: 0, y: kTopNavHeight, width: UIScreen.screenWidth, height: UIScreen.screenHeight - kTopNavHeight))
        
        item.textColor = ZUIColor.shared.HtmlContentColor
        item.font = UIFont.systemFont(ofSize: 15)
        item.isEditable = false
        item.isScrollEnabled = true
        item.backgroundColor = .clear
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.textContent)
    }
}
