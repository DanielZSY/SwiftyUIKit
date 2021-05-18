
import UIKit
import SwiftyLocalKit
import ESPullToRefresh

open class ZBaseCV: UICollectionView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.alwaysBounceVertical = false
        self.scrollsToTop = false
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.backgroundView?.frame = self.bounds
        self.backgroundView?.backgroundColor = .clear
    }
}
