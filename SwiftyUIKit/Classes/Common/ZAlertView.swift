
import UIKit
import SwiftyLocalKit

public struct ZAlertView {
    
    /// 显示弹框  row 0 cancel 1 button
    public static func showAlertView(vc: UIViewController? = nil, title: String? = nil, message: String? = nil, button: String? = "Continue", cancel: String? = "Cancel", callBack: ((_ row: Int) -> Void)? = nil) {
        let itemVC = ZAlertViewController.init(title: title, message: message, button: button, cancel: cancel, callBack: { row in
            callBack?(row)
        })
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
    /// 显示多个ActionSheet
    public static func showActionSheetView(vc: UIViewController? = nil, title: String? = nil, message: String? = nil, buttons: [String], cancel: String? = "Cancel", callBack: ((_ row: Int) -> Void)? = nil) {
        let itemVC = ZAlertSheetViewController.init(title: title, message: message, buttons: buttons, cancel: cancel, callBack: { row in
            callBack?(row)
        })
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: false, completion: nil)
    }
}
