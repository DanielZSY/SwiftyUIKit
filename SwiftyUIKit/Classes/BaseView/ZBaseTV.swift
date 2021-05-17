
import UIKit
import SwiftyLocalKit
import ESPullToRefresh

open class ZBaseTV: UITableView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init(frame: CGRect) {
        self.init(frame: frame, style: UITableView.Style.plain)
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.setupViewUI()
    }
    private func setupViewUI() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedRowHeight = UITableView.automaticDimension
        self.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.separatorColor = .clear
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.backgroundView?.frame = self.bounds
        self.backgroundView?.backgroundColor = .clear
    }
}
