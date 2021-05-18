
import UIKit
import BFKit
import SwiftyLocalKit

/// 文本输入框
open class ZTextField: UITextField {
    
    public override var tag: Int {
        didSet {
            self.toolBarView.tag = self.tag
        }
    }
    /// 设置是否能上一步
    public var isPre: Bool = false {
        didSet {
            self.toolBarView.isPre = self.isPre
        }
    }
    /// 设置是否能下一步
    public var isNext: Bool = false {
        didSet {
            self.toolBarView.isNext = self.isNext
        }
    }
    public var isShowBorder: Bool = false {
        didSet {
            if isShowBorder {
                self.viewLine.backgroundColor = ZUIColor.shared.InputBorderNormalColor
            } else {
                self.viewLine.backgroundColor = ZUIColor.shared.InputBackgroundColor
            }
        }
    }
    public var isCopy: Bool = true
    public var isShouldBeginEditing: Bool = true
    public var maxLength: Int = 0
    public var onTextBeginEdit: (() -> Void)?
    public var onTextEndEdit: ((_ text: String) -> Void)?
    public var onTextChanged: ((_ text: String) -> Void)?
    /// 工具栏按钮事件 1 pre 2 next
    public var onToolButtonClick: ((_ row: Int) -> Void)?
    public var placeholderColor: UIColor? = ZUIColor.shared.InputPromptColor
    public var borderNormalColor: UIColor? = ZUIColor.shared.InputBorderNormalColor
    public var borderSelectColor: UIColor? = ZUIColor.shared.InputBorderSelectColor
    
    public var fontSize: CGFloat = 15 {
        didSet {
            self.font = UIFont.systemFont(self.fontSize)
        }
    }
    public var boldSize: CGFloat = 15 {
        didSet {
            self.font = UIFont.boldSystemFont(self.fontSize)
        }
    }
    public var isBoldFont: Bool = true
    public var isShowToolBar: Bool = true {
        didSet {
            if self.isShowToolBar {
                self.inputAccessoryView = self.toolBarView
            } else {
                self.inputAccessoryView = nil
            }
        }
    }
    private lazy var toolBarView: ZToolBarView = {
        let item = ZToolBarView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.screenWidth, height: 45))
        item.onButtonClick = { row in
            switch row {
            case 0: self.resignFirstResponder()
            default: self.onToolButtonClick?(row)
            }
        }
        return item
    }()
    private lazy var viewLine: UIView = {
        let item = UIView.init(frame: CGRect.init(0, self.height - 1, self.width, 1))
        
        return item
    }()
    public override var placeholder: String? {
        didSet {
            let attribString = NSMutableAttributedString.init(string: self.placeholder ?? "")
            
            let length = self.placeholder?.length ?? 0
            let range = NSRange.init(location: 0, length: length)
            var font = UIFont.systemFont(self.fontSize)
            if self.isBoldFont {
                font = UIFont.boldSystemFont(self.boldSize)
            }
            let color = self.placeholderColor
            attribString.addAttributes([NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color], range: range)
            self.attributedPlaceholder = attribString
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        
        self.text = text
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(self.boldSize)
        if self.isBoldFont {
            self.font = UIFont.boldSystemFont(self.fontSize)
        }
        self.returnKeyType = UIReturnKeyType.done
        self.inputAccessoryView = self.toolBarView
        self.textColor = ZUIColor.shared.InputTextColor
        self.tintColor = ZUIColor.shared.InputCursorColor
        self.backgroundColor = ZUIColor.shared.InputBackgroundColor
        self.delegate = self
        
        self.addSubview(self.viewLine)
    }
    deinit {
        self.delegate = nil
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewLine.width = self.width
    }
    public func addLeftAndRightSpace(_ width: CGFloat ,_ height: CGFloat) {
        self.leftView = UIView.init(frame: CGRect.init(0, 0, (width), (height)))
        self.rightView = UIView.init(frame: CGRect.init(0, 0, (width), (height)))
        self.leftViewMode = UITextField.ViewMode.always
        self.rightViewMode = UITextField.ViewMode.always
    }
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UITextField.paste(_:))
            || action == #selector(UITextField.copy(_:))
            || action == #selector(UITextField.select(_:))
            || action == #selector(UITextField.selectAll(_:)) {
            return self.isCopy
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
extension ZTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        var textLength = currentText.length + string.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: string)
            textLength = newText.length
            self.onTextChanged?(newText)
        } else {
            self.onTextChanged?(currentText)
        }
        if self.maxLength > 0 && textLength > self.maxLength {
            return false
        }
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.onTextBeginEdit?()
        if self.isShowBorder {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewLine.backgroundColor = self.borderSelectColor
            })
        }
        return self.isShouldBeginEditing
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.isShowBorder {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewLine.backgroundColor = self.borderNormalColor
            })
        }
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.onTextEndEdit?(textField.text ?? "")
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
