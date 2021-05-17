
import UIKit
import BFKit
import SwiftyLocalKit

/// 底部选择
public class ZAlertSheetViewController: ZBaseViewController {

    public var message: String?
    public var cancel: String? = "Cancel"
    public var buttons: [String] = [String]()
    
    private var onButtonItemClick: ((_ row: Int) -> Void)?
    
    private lazy var viewBG: UIView = {
        let temp = UIView.init(frame: CGRect.main())
        temp.alpha = 0
        temp.backgroundColor = .black
        return temp
    }()
    private lazy var viewContent: UIView = {
        let temp = UIView.init(frame: CGRect.init(10.scale, kScreenHeight, kScreenWidth - 20.scale, 50.scale * CGFloat(buttons.count)))
        temp.backgroundColor = ZUIColor.shared.alertBackgroundColor
        temp.border(color: .clear, radius: 15, width: 0)
        return temp
    }()
    private lazy var lbTitle: UILabel = {
        let temp = UILabel.init(frame: CGRect.init(20.scale, 10.scale, viewContent.width - 40.scale, 20.scale))
        temp.textAlignment = .center
        temp.fontSize = ZUIColor.shared.alertTitleSize
        temp.numberOfLines = 1
        temp.text = title
        temp.textColor = ZUIColor.shared.alertTitleColor
        temp.adjustsFontSizeToFitWidth = true
        return temp
    }()
    private lazy var lbMessage: UILabel = {
        let temp = UILabel.init(frame: CGRect.init(20.scale, 10.scale, viewContent.width - 40.scale, 20.scale))
        temp.textAlignment = .center
        temp.fontSize = ZUIColor.shared.alertMessageSize
        temp.numberOfLines = 0
        temp.text = message
        temp.textColor = ZUIColor.shared.alertMessageColor
        return temp
    }()
    private lazy var btnCancel: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(10.scale, viewContent.y + viewContent.height + 10.scale, kScreenWidth - 20.scale, 50.scale))
        temp.adjustsImageWhenHighlighted = false
        temp.titleLabel?.fontSize = 18
        temp.setTitle(cancel, for: .normal)
        temp.setTitleColor(ZUIColor.shared.alertSheetCancelColor, for: .normal)
        temp.border(color: .clear, radius: 15, width: 0)
        temp.backgroundColor = ZUIColor.shared.alertBackgroundColor
        return temp
    }()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    public required init(title: String? = nil, message: String? = nil, buttons: [String], cancel: String? = "Cancel", callBack: @escaping ((_ row: Int) -> Void)) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.message = message
        self.cancel = cancel
        self.buttons.append(contentsOf: buttons)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.onButtonItemClick = { row in
            callBack(row)
        }
    }
    deinit {
        self.onButtonItemClick = nil
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.view.backgroundColor = .clear
        self.view.addSubview(self.viewBG)
        self.view.addSubview(self.viewContent)
        self.view.addSubview(self.btnCancel)
        self.view.sendSubviewToBack(self.viewBG)
        
        self.viewBG.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "viewbgtapevent:"))
        self.btnCancel.addTarget(self, action: "btnCancelClick", for: .touchUpInside)
        
        self.viewContent.addSubview(self.lbTitle)
        self.viewContent.addSubview(self.lbMessage)
        
        if let lbH = self.lbMessage.text?.getHeight(self.lbMessage.font, width: self.lbMessage.width) {
            self.lbMessage.height = lbH
        } else {
            self.lbMessage.height = 0
        }
        if let lbH = self.lbTitle.text?.getHeight(self.lbTitle.font, width: self.lbTitle.width) {
            self.lbTitle.height = lbH
            self.lbMessage.y = self.lbTitle.y + self.lbTitle.height + 10.scale
        } else {
            self.lbTitle.height = 0
            self.lbMessage.y = self.lbTitle.y
        }
        var btny: CGFloat = 0
        if self.lbTitle.height > 0 {
            btny = self.lbTitle.y + self.lbTitle.height + 15.scale
        }
        if self.lbMessage.height > 0 {
            btny = self.lbMessage.y + self.lbMessage.height + 15.scale
        }
        self.viewContent.height = btny + 50.scale * CGFloat(buttons.count)
        let btnw = self.viewContent.width
        for (i, text) in self.buttons.enumerated() {
            let temp = UIButton.init(frame: CGRect.init(0, btny, btnw, 50.scale))
            temp.tag = 10 + i
            temp.backgroundColor = .clear
            temp.adjustsImageWhenHighlighted = false
            temp.setTitle(text, for: .normal)
            temp.setTitleColor(ZUIColor.shared.alertSheetButtonColor, for: .normal)
            temp.titleLabel?.fontSize = 18
            temp.addTarget(self, action: "btnButtonClick:", for: .touchUpInside)
            self.viewContent.addSubview(temp)
           
            let line = UIView.init(frame: CGRect.init(0, btny-1, btnw, 1))
            line.backgroundColor = ZUIColor.shared.alertLineColor
            self.viewContent.addSubview(line)
            
            btny += 50.scale
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZCurrentVC.shared.currentPresentVC = self
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewContent.y >= kScreenHeight {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewBG.alpha = 0.1
                self.viewContent.y = kScreenHeight - self.viewContent.height - self.btnCancel.height - 15.scale
                self.btnCancel.y = self.viewContent.y + self.viewContent.height + 10.scale
            })
        }
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
    @objc private func btnButtonClick(_ sender: UIButton) {
        self.onButtonItemClick?(sender.tag - 10)
        self.btnCancelClick()
    }
    @objc private func viewbgtapevent(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.btnCancelClick()
        default: break
        }
    }
    @objc private func btnCancelClick() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0
            self.viewContent.y = kScreenHeight
            self.btnCancel.y = kScreenHeight + self.viewContent.height + 10.scale
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
}
