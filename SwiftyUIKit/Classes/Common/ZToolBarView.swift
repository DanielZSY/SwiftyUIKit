
import UIKit
import SwiftyLocalKit

/// 顶部工具栏
public class ZToolBarView: UIView {
    /// 按钮点击回调事件
    public var onButtonClick: ((_ row: Int) -> Void)?
    /// 设置是否能上一步
    public var isPre: Bool = false {
        didSet {
            self.btnPre.isEnabled = self.isPre
        }
    }
    /// 设置是否能下一步
    public var isNext: Bool = false {
        didSet {
            self.btnNext.isEnabled = self.isNext
        }
    }
    /// 设置当前工具栏索引 1 开始
    public override var tag: Int {
        didSet {
            self.btnPre.isHidden = false
            self.btnNext.isHidden = false
        }
    }
    private lazy var btnDone: UIButton = {
        let item = UIButton.init(frame: CGRect.init(self.width - 50.scale, 0, 50.scale, self.height))
        item.adjustsImageWhenHighlighted = false
        item.setTitle("Done", for: .normal)
        item.titleLabel?.boldSize = 16
        item.tag = 0
        return item
    }()
    private lazy var btnPre: UIButton = {
        let item = UIButton.init(frame: CGRect.init(0, 0, 50.scale, self.height))
        item.adjustsImageWhenHighlighted = false
        item.setTitle("Pre", for: .normal)
        item.setTitle("Pre", for: .disabled)
        item.titleLabel?.boldSize = 16
        item.isHidden = true
        item.tag = 1
        return item
    }()
    private lazy var btnNext: UIButton = {
        let item = UIButton.init(frame: CGRect.init(50.scale, 0, 50.scale, self.height))
        item.adjustsImageWhenHighlighted = false
        item.setTitle("Next", for: .normal)
        item.setTitle("Next", for: .disabled)
        item.titleLabel?.boldSize = 16
        item.isHidden = true
        item.tag = 2
        return item
    }()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.btnDone)
        self.addSubview(self.btnPre)
        self.addSubview(self.btnNext)
        
        self.backgroundColor = ZUIColor.shared.InputToolBarBackgroundColor
        
        self.btnDone.setTitleColor(ZUIColor.shared.InputToolBarNormalColor, for: .normal)
        
        self.btnPre.setTitleColor(ZUIColor.shared.InputToolBarNormalColor, for: .normal)
        self.btnPre.setTitleColor(ZUIColor.shared.InputToolBarDisabledColor, for: .disabled)
        
        self.btnNext.setTitleColor(ZUIColor.shared.InputToolBarNormalColor, for: .normal)
        self.btnNext.setTitleColor(ZUIColor.shared.InputToolBarDisabledColor, for: .disabled)
        
        self.btnDone.addTarget(self, action: #selector(self.btnItemClick(_:)), for: .touchUpInside)
        self.btnPre.addTarget(self, action: #selector(self.btnItemClick(_:)), for: .touchUpInside)
        self.btnNext.addTarget(self, action: #selector(self.btnItemClick(_:)), for: .touchUpInside)
    }
    @objc private func btnItemClick(_ sender: UIButton) {
        self.onButtonClick?(sender.tag)
    }
}
