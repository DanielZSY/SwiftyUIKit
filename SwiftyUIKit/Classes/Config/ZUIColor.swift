
import UIKit
import PKHUD

public struct ZUIColor {
    
    public static var shared = ZUIColor.init()
    
    internal var hudWaitTime: Double = 5
    internal var hudLabelSize: CGFloat = 15
    internal var hudBackgroundColor: UIColor = "#100D13".color
    internal var hudImage: UIImage? = PKHUDAssets.progressCircularImage.withRenderingMode(.alwaysTemplate)
    internal var hudLabelText: String = "Wait..."
    internal var hudImageColor: UIColor = "#7037E9".color
    internal var hudTextColor: UIColor = "#E9E9E9".color
    internal var hudMessageColor: UIColor = "#E9E9E9".color
    
    /// 配置等待样式
    public static func configHudStyle(time: Double, size: CGFloat, bgColor: String, image: UIImage, imageColor: String, text: String, textColor: String, messageColor: String) {
        ZUIColor.shared.hudWaitTime = time
        ZUIColor.shared.hudLabelSize = size
        ZUIColor.shared.hudBackgroundColor = bgColor.color
        ZUIColor.shared.hudImage = image
        ZUIColor.shared.hudImageColor = imageColor.color
        ZUIColor.shared.hudLabelText = text
        ZUIColor.shared.hudTextColor = textColor.color
        ZUIColor.shared.hudMessageColor = messageColor.color
    }
    
    internal var alertBackgroundColor: UIColor = "#2D2638".color
    internal var alertLineColor: UIColor = "#1F1825".color
    internal var alertTitleSize: CGFloat = 18
    internal var alertMessageSize: CGFloat = 16
    internal var alertTitleColor: UIColor = "#FFFFFF".color
    internal var alertMessageColor: UIColor = "#FFFFFF".color
    internal var alertButtonColor: UIColor = "#7037E9".color
    internal var alertSheetButtonColor: UIColor = "#FFFFFF".color
    internal var alertCancelColor: UIColor = "#56565C".color
    internal var alertSheetCancelColor: UIColor = "#7037E9".color
    
    /// 配置弹窗样式
    public static func configAlertColor(bgColor: String, lineColor: String, titleSize: CGFloat, messageSize: CGFloat, titleColor: String, messageColor: String, alertButtonColor: String, sheetButtonColor: String, alertCancelColor: String, sheetCancelColor: String) {
        ZUIColor.shared.alertBackgroundColor = bgColor.color
        ZUIColor.shared.alertLineColor = lineColor.color
        ZUIColor.shared.alertTitleSize = titleSize
        ZUIColor.shared.alertMessageSize = messageSize
        ZUIColor.shared.alertTitleColor = titleColor.color
        ZUIColor.shared.alertMessageColor = messageColor.color
        ZUIColor.shared.alertButtonColor = alertButtonColor.color
        ZUIColor.shared.alertSheetButtonColor = sheetButtonColor.color
        ZUIColor.shared.alertCancelColor = alertCancelColor.color
        ZUIColor.shared.alertSheetCancelColor = sheetCancelColor.color
    }
    
    public var NavBarTintColor: UIColor = "#FFFFFF".color
    public var NavBarLineColor: UIColor = "#FFFFFF".color
    public var NavBarButtonColor: UIColor = "#000000".color
    public var NavBarTitleColor: UIColor = "#000000".color
    
    public var TabBarTintColor: UIColor = "#FFFFFF".color
    public var TabBarLineColor: UIColor = "#FFFFFF".color
    public var TabBarButtonNormalColor: UIColor = "#D3D4ED".color
    public var TabBarButtonSelectColor: UIColor = "#000000".color
    public var TabBarTitleNormalColor: UIColor = "#D3D4ED".color
    public var TabBarTitleSelectColor: UIColor = "#000000".color
    
    public var ViewBackgroundColor: UIColor = "#FFFFFF".color
    public var ViewBorderColor: UIColor = "#CFCFCF".color
    public var LabelTitleColor: UIColor = "#242424".color
    public var LabelDescColor: UIColor = "#8E8E8E".color
    public var HtmlContentColor: UIColor = "#FFFFFF".color
    
    public var InputBackgroundColor: UIColor = "#FFFFFF".color
    public var InputBorderNormalColor: UIColor = "#FFFFFF".color
    public var InputBorderSelectColor: UIColor = "#FFFFFF".color
    public var InputCursorColor: UIColor = "#000000".color
    public var InputPromptColor: UIColor = "#CFCFCF".color
    public var InputTextColor: UIColor = "#000000".color
    public var InputToolBarNormalColor: UIColor = "#327BF6".color
    public var InputToolBarDisabledColor: UIColor = "#655C70".color
    public var InputToolBarBackgroundColor: UIColor = "#FFFFFF".color
    
    /// 配置导航栏颜色
    public func configNavColor(bgColor: String, lineColor: String, buttonColor: String, titleColor: String) {
        ZUIColor.shared.NavBarTintColor = bgColor.color
        ZUIColor.shared.NavBarLineColor = lineColor.color
        ZUIColor.shared.NavBarButtonColor = buttonColor.color
        ZUIColor.shared.NavBarTitleColor = titleColor.color
    }
    /// 配置Tabbar颜色
    public func configTabColor(bgColor: String, lineColor: String, buttonNormalColor: String, buttonSelectColor: String, titleNormalColor: String, titleSelectColor: String) {
        ZUIColor.shared.TabBarTintColor = bgColor.color
        ZUIColor.shared.TabBarLineColor = lineColor.color
        ZUIColor.shared.TabBarButtonNormalColor = buttonNormalColor.color
        ZUIColor.shared.TabBarButtonSelectColor = buttonSelectColor.color
        ZUIColor.shared.TabBarTitleNormalColor = titleNormalColor.color
        ZUIColor.shared.TabBarTitleSelectColor = titleSelectColor.color
    }
    /// 配置View颜色
    public func configViewColor(bgColor: String, borderColor: String, titleColor: String, descColor: String, htmlColor: String) {
        ZUIColor.shared.ViewBackgroundColor = bgColor.color
        ZUIColor.shared.ViewBorderColor = borderColor.color
        ZUIColor.shared.LabelTitleColor = titleColor.color
        ZUIColor.shared.LabelDescColor = descColor.color
        ZUIColor.shared.HtmlContentColor = htmlColor.color
    }
    /// 配置输入框颜色
    public func configInputColor(bgColor: UIColor, borderNormalColor: String, borderSelectColor: String, cursorColor: String, textColor: String, promptColor: String, toolBarBGColor: String, toolBarNormalColor: String, toolBarDisabledColor: String) {
        ZUIColor.shared.InputBackgroundColor = bgColor
        ZUIColor.shared.InputBorderNormalColor = borderNormalColor.color
        ZUIColor.shared.InputBorderSelectColor = borderSelectColor.color
        ZUIColor.shared.InputCursorColor = cursorColor.color
        ZUIColor.shared.InputTextColor = textColor.color
        ZUIColor.shared.InputPromptColor = promptColor.color
        ZUIColor.shared.InputToolBarNormalColor = toolBarNormalColor.color
        ZUIColor.shared.InputToolBarDisabledColor = toolBarDisabledColor.color
        ZUIColor.shared.InputToolBarBackgroundColor = toolBarBGColor.color
    }
}

