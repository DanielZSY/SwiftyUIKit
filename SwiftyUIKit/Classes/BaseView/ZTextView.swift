
import UIKit
import BFKit
import SwiftyLocalKit

open class ZTextView: UIView {
    
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
    public var onTextBeginEdit: (() -> Void)?
    public var onTextEndEdit: ((_ text: String) -> Void)?
    public var onTextChangedEdit: ((_ text: String) -> Void)?
    /// 工具栏按钮事件 1 pre 2 next
    public var onToolButtonClick: ((_ row: Int) -> Void)?
    public var paddingSpace: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    public var placeholderColor: UIColor? = ZUIColor.shared.InputPromptColor {
        didSet {
            self.lbPlaceholder.textColor = placeholderColor
        }
    }
    public override var backgroundColor: UIColor? {
        didSet {
            self.textView.backgroundColor = self.backgroundColor
        }
    }
    public var textColor: UIColor? {
        didSet {
            self.textView.textColor = self.textColor
        }
    }
    public override var tintColor: UIColor? {
        didSet {
            self.textView.tintColor = self.tintColor
        }
    }
    public var placeholder: String = "" {
        willSet {
            self.lbPlaceholder.text = newValue
        }
    }
    public var text: String {
        set(newValue) {
            self.textView.text = newValue
            self.lbPlaceholder.isHidden = (newValue.length > 0)
        }
        get {
            return self.textView.text
        }
    }
    public var fontSize: CGFloat = (18) {
        willSet {
            self.textView.font = UIFont.systemFont(newValue)
        }
    }
    public var textInputAccessoryView: UIView? = nil {
        willSet {
            self.textView.inputAccessoryView = newValue
        }
    }
    public var isShowToolBar: Bool = true {
        didSet {
            if self.isShowToolBar {
                self.textView.inputAccessoryView = self.toolBarView
            } else {
                self.textView.inputAccessoryView = nil
            }
        }
    }
    public var maxLength: Int = 0
    public var isMultiline: Bool = true
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
    private lazy var textView: UITextView = {
        let item = UITextView.init(frame: CGRect.init(paddingSpace.left, paddingSpace.top, self.width - paddingSpace.left - paddingSpace.right, self.height - paddingSpace.top - paddingSpace.bottom))
        
        item.text = ""
        item.scrollsToTop = false
        item.isUserInteractionEnabled = true
        item.backgroundColor = .white
        item.font = UIFont.systemFont(14)
        item.textColor = ZUIColor.shared.InputTextColor
        item.tintColor = ZUIColor.shared.InputCursorColor
        item.backgroundColor = ZUIColor.shared.InputBackgroundColor
        item.inputAccessoryView = self.toolBarView
        
        return item
    }()
    private lazy var lbPlaceholder: UILabel = {
        let item = UILabel.init(frame: CGRect.init(5, 5, self.textView.width - 10, 20))
        
        item.isUserInteractionEnabled = false
        item.font = UIFont.systemFont(ofSize: 14)
        item.textColor = self.placeholderColor
        item.text = self.placeholder
        item.numberOfLines = 0
        
        return item
    }()
    private var labelHeight: CGFloat = 22
    public var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textView.keyboardType = keyboardType
        }
    }
    public var returnKeyType: UIReturnKeyType = .default {
        didSet {
            self.textView.returnKeyType = returnKeyType
        }
    }
    public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet {
            self.textView.keyboardAppearance = keyboardAppearance
        }
    }
    public override var frame: CGRect {
        didSet {
            self.textView.frame = CGRect.init(paddingSpace.left, paddingSpace.top, self.width - paddingSpace.left - paddingSpace.right, self.height - paddingSpace.top - paddingSpace.bottom)
            self.labelHeight = self.placeholder.getHeight(self.lbPlaceholder.font, width: self.textView.width - 10)
            self.lbPlaceholder.frame = CGRect.init(x: 5, y: 7, width: self.textView.width - 10, height: self.labelHeight)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textView)
        self.textView.addSubview(self.lbPlaceholder)
        self.sendSubviewToBack(self.textView)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = ZUIColor.shared.InputBackgroundColor
        
        self.textView.delegate = self
    }
    deinit {
        self.textView.delegate = nil
    }
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.frame = CGRect.init(paddingSpace.left, paddingSpace.top, self.width - paddingSpace.left - paddingSpace.right, self.height - paddingSpace.top - paddingSpace.bottom)
        self.labelHeight = self.placeholder.getHeight(self.lbPlaceholder.font, width: self.textView.width - 10)
        self.lbPlaceholder.frame = CGRect.init(5, 7, self.textView.width - 10, self.labelHeight)
    }
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return self.textView.becomeFirstResponder()
    }
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return self.textView.resignFirstResponder()
    }
}
extension ZTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !self.isMultiline {
            if text == "\n" {
                self.onTextEndEdit?(textView.text)
                self.onTextChangedEdit?(textView.text)
                let _ = textView.resignFirstResponder()
                return false
            }
        }
        let currentText = textView.text ?? ""
        var textLength = currentText.length + text.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: text)
            textLength = newText.length
            self.onTextChangedEdit?(newText)
        } else {
            self.onTextChangedEdit?(currentText)
        }
        self.lbPlaceholder.isHidden = textLength > 0
        if self.maxLength > 0 && textLength > self.maxLength {
            return false
        }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.onTextBeginEdit?()
        return true
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.onTextEndEdit?(textView.text)
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        self.onTextChangedEdit?(textView.text)
    }
}
