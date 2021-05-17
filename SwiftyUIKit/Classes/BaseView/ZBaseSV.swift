
import UIKit
import SwiftyLocalKit
import ESPullToRefresh

open class ZBaseSV: UIScrollView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.scrollsToTop = false
        self.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
    }
}
extension UIScrollView {
    private struct AssociatedKey {
        static var onHeader = "onHeader"
        static var onFooter = "onFooter"
    }
    public var onRefreshHeader: (() -> Void)? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.onHeader) as? (() -> Void) else { return nil }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.onHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onRefreshFooter: (() -> Void)? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.onFooter) as? (() -> Void) else { return nil }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.onFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func addRefreshHeader() {
        self.es.addPullToRefresh { [unowned self] in
            self.onRefreshHeader?()
        }
    }
    public func addRefreshFooter() {
        self.es.addInfiniteScrolling { [unowned self] in
            self.onRefreshFooter?()
        }
        self.es.base.footer?.isHidden = true
    }
    public func endRefreshHeader() {
        self.es.stopPullToRefresh(ignoreFooter: true)
    }
    public func endRefreshHeader(_ count: Int) {
        if count < kPageCount {
            self.es.stopPullToRefresh(ignoreFooter: true)
        } else {
            self.es.stopPullToRefresh(ignoreFooter: false)
        }
    }
    public func endRefreshFooter() {
        self.es.stopLoadingMore()
    }
    public func endRefreshFooter(_ count: Int) {
        self.es.stopLoadingMore()
        if count < kPageCount {
            self.es.noticeNoMoreData()
        }
    }
}
