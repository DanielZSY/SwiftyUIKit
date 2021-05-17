import UIKit
import BFKit
import SwiftyLocalKit

public class ZAlertViewController: ZBaseViewController {
    
    public var message: String?
    public var button: String? = "Continue"
    public var cancel: String? = "Cancel"
    
    public var onButtonItemClick: ((_ row: Int) -> Void)?
    
    private lazy var viewBG: UIView = {
        let temp = UIView.init(frame: CGRect.main())
        temp.alpha = 0
        temp.backgroundColor = .black
        return temp
    }()
    private lazy var viewContent: UIView = {
        let temp = UIView.init(frame: CGRect.init(kScreenWidth/2 - 250.scale/2, kScreenHeight/2, 250.scale, 0))
        temp.backgroundColor = ZUIColor.shared.alertBackgroundColor
        temp.border(color: .clear, radius: 15, width: 0)
        return temp
    }()
    private lazy var lbTitle: UILabel = {
        let temp = UILabel.init(frame: CGRect.init(20.scale, 20.scale, viewContent.width - 40.scale, 20.scale))
        temp.textAlignment = .center
        temp.fontSize = ZUIColor.shared.alertTitleSize
        temp.numberOfLines = 1
        temp.text = title
        temp.textColor = ZUIColor.shared.alertTitleColor
        temp.adjustsFontSizeToFitWidth = true
        return temp
    }()
    private lazy var lbMessage: UILabel = {
        let temp = UILabel.init(frame: CGRect.init(20.scale, 20.scale, viewContent.width - 40.scale, 20.scale))
        temp.textAlignment = .center
        temp.fontSize = ZUIColor.shared.alertMessageSize
        temp.numberOfLines = 0
        temp.text = message
        temp.textColor = ZUIColor.shared.alertMessageColor
        return temp
    }()
    private lazy var btnContinue: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(0, 0, viewContent.width/2, 45.scale))
        temp.tag = 1
        temp.adjustsImageWhenHighlighted = false
        temp.titleLabel?.fontSize = 18
        temp.setTitle(self.button, for: .normal)
        temp.setTitleColor(ZUIColor.shared.alertButtonColor, for: .normal)
        return temp
    }()
    private lazy var btnCancel: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(viewContent.width/2, 0, viewContent.width/2, 45.scale))
        temp.tag = 0
        temp.adjustsImageWhenHighlighted = false
        temp.titleLabel?.fontSize = 18
        temp.setTitle(self.cancel, for: .normal)
        temp.setTitleColor(ZUIColor.shared.alertCancelColor, for: .normal)
        return temp
    }()
    private lazy var viewLineHorizontal: UIView = {
        let temp = UIView.init(frame: CGRect.init(1, 0, viewContent.width - 2, 1))
        temp.backgroundColor = ZUIColor.shared.alertLineColor
        return temp
    }()
    private lazy var viewLineVertical: UIView = {
        let temp = UIView.init(frame: CGRect.init(viewContent.width/2, 1, 1, 45.scale - 2))
        temp.backgroundColor = ZUIColor.shared.alertLineColor
        return temp
    }()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    public required init(title: String? = nil, message: String? = nil, button: String? = "Continue", cancel: String? = "Cancel", callBack: @escaping ((_ row: Int) -> Void)) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.message = message
        self.button = button
        self.cancel = cancel
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
        
        self.setupViewUI()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setShowAnimation()
        ZCurrentVC.shared.currentPresentVC = self
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
    private func setupViewUI() {
        self.showType = 2
        self.view.backgroundColor = .clear
        self.view.addSubview(self.viewBG)
        self.view.addSubview(self.viewContent)
        self.view.addSubview(self.btnCancel)
        self.view.sendSubviewToBack(self.viewBG)
        
        self.viewBG.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "viewbgtapevent:"))
        self.btnCancel.addTarget(self, action: "btnCancelClick", for: .touchUpInside)
        self.btnContinue.addTarget(self, action: "btnContinueClick", for: .touchUpInside)
        
        self.viewContent.addSubview(self.lbTitle)
        self.viewContent.addSubview(self.lbMessage)
        self.viewContent.addSubview(self.btnCancel)
        self.viewContent.addSubview(self.btnContinue)
        self.viewContent.addSubview(self.viewLineHorizontal)
        self.viewContent.addSubview(self.viewLineVertical)
        
        if let lbH = self.lbMessage.text?.getHeight(self.lbMessage.font, width: self.lbMessage.width) {
            self.lbMessage.height = lbH
        } else {
            self.lbMessage.height = 0
        }
        if let lbH = self.lbTitle.text?.getHeight(self.lbTitle.font, width: self.lbTitle.width) {
            self.lbTitle.height = lbH
            self.lbMessage.y = self.lbTitle.y + self.lbTitle.height + 20.scale
        } else {
            self.lbTitle.height = 0
            self.lbMessage.y = self.lbTitle.y
        }
        var btny: CGFloat = 65.scale
        if self.lbTitle.height > 0 {
            btny = self.lbTitle.y + self.lbTitle.height + 25.scale
        }
        if self.lbMessage.height > 0 {
            btny = self.lbMessage.y + self.lbMessage.height + 25.scale
        }
        self.viewContent.height = btny + self.btnContinue.height
        self.viewContent.y = kScreenHeight/2 - self.viewContent.height/2
        let btnw = self.viewContent.width
        self.btnCancel.y = btny
        self.btnContinue.y = btny
        self.viewLineHorizontal.y = btny
        self.viewLineVertical.y = self.viewLineHorizontal.y + 1
        if self.cancel == nil || self.button == nil {
            let text = self.cancel == nil ? self.button : self.cancel
            self.btnContinue.setTitle(text, for: .normal)
            self.btnCancel.isHidden = true
            self.btnContinue.width = self.viewContent.width
            self.viewLineVertical.isHidden = true
        }
        self.viewContent.alpha = 0
    }
    private func setShowAnimation() {
        if self.viewContent.alpha == 1 {
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.1
        })
        let tfAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        tfAnimation.duration = 0.25
        tfAnimation.fillMode = .forwards
        tfAnimation.autoreverses = false
        tfAnimation.isRemovedOnCompletion = true
        tfAnimation.values = [NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)),
                              NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1.0)),
                              NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0))]
        tfAnimation.keyTimes = [0.0, 0.5, 1.0]
        tfAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)]
        self.viewContent.alpha = 1
        self.viewContent.layer.add(tfAnimation, forKey: "transform")
    }
    @objc private func btnContinueClick() {
        self.onButtonItemClick?(1)
        self.dismissVC()
    }
    @objc private func btnCancelClick() {
        self.onButtonItemClick?(0)
        self.dismissVC()
    }
    @objc private func viewbgtapevent(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.dismissVC()
        default: break
        }
    }
    private func dismissVC() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0
            self.viewContent.alpha = 0
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
}
