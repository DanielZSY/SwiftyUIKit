
import UIKit
import PKHUD
import Toast_Swift
import SwiftyLocalKit

/// HUD
public struct ZProgressHUD {
    
    public static func dismiss() {
        PKHUD.sharedHUD.hide()
    }
    public static func show(vc: UIViewController? = nil, text: String? = nil) {
        let contentView = PKHUDProgressView.init()
        contentView.backgroundColor = ZUIColor.shared.hudBackgroundColor
        contentView.imageView.image = ZUIColor.shared.hudImage
        contentView.imageView.tintColor = ZUIColor.shared.hudImageColor
        contentView.subtitleLabel.textColor = ZUIColor.shared.hudTextColor
        contentView.subtitleLabel.font = UIFont.systemFont(ofSize: ZUIColor.shared.hudLabelSize)
        contentView.subtitleLabel.text = text == nil ? ZUIColor.shared.hudLabelText : text
        PKHUD.sharedHUD.contentView = contentView
        PKHUD.sharedHUD.show(onView: vc?.view)
    }
    public static func showMessage(vc: UIViewController?, text: String, position: ToastPosition = .bottom) {
        ToastManager.shared.position = position
        var style = ToastStyle()
        style.messageColor = ZUIColor.shared.hudMessageColor
        style.backgroundColor = ZUIColor.shared.hudBackgroundColor
        if vc != nil {
            vc?.view.makeToast(text, duration: ZUIColor.shared.hudWaitTime, style: style)
            return
        }
        UIApplication.shared.keyWindow?.makeToast(text, duration: ZUIColor.shared.hudWaitTime, style: style)
    }
}
