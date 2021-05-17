
import UIKit
import SwiftyLocalKit

public class ZNoDataView: UIView {
    
    fileprivate var z_datacount: Int = 0 {
        didSet {
            z_viewai.stopAnimating()
            z_viewcontent.isHidden = z_datacount > 0
        }
    }
    fileprivate lazy var z_viewai: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(style: .gray)
        z_temp.frame = CGRect.init(origin: CGPoint.init(x: self.width/2 - 15, y: self.height/2 - 15), size: CGSize.init(width: 30, height: 30))
        return z_temp
    }()
    fileprivate lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.isHidden = true
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    fileprivate lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.center.x, self.center.y, 10, 10))
        
        return z_temp
    }()
    fileprivate lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imageicon.y + z_imageicon.height + 15.scale, self.width, 25))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubview(z_viewcontent)
        self.addSubview(z_viewai)
        
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_imageicon)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    fileprivate func startAnimating() {
        self.z_viewai.startAnimating()
    }
}
extension UIScrollView {
    
    private struct AssociatedKey {
        static var aiviewKey = "aiviewKey"
    }
    var viewNodata: ZNoDataView {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.aiviewKey) as? ZNoDataView else {
                let view = ZNoDataView.init(frame: self.bounds)
                self.viewNodata = view
                return view
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.aiviewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension UICollectionView {
    
    final func addNoDataView(image: UIImage, text: String = "No Data", textColor: UIColor = "#FFFFFF".color, textSize: CGFloat = 18, imageY: CGFloat = 100) {
        self.viewNodata.z_imageicon.image = image
        self.viewNodata.z_lbtitle.text = text
        self.viewNodata.z_lbtitle.textColor = textColor
        self.viewNodata.z_lbtitle.fontSize = textSize
        let imagesize = self.viewNodata.z_imageicon.image?.size ?? CGSize.init(width: 10.scale, height: 10.scale)
        let imagey = imageY == 0 ? (self.height/2 - imagesize.height/2) : imageY
        self.viewNodata.z_imageicon.frame = CGRect.init(self.width/2 - imagesize.width/2, imagey, imagesize.width, imagesize.height)
        self.viewNodata.z_lbtitle.y = self.viewNodata.z_imageicon.y + self.viewNodata.z_imageicon.height + 15.scale
        self.backgroundView = self.viewNodata
        self.backgroundView?.frame = self.bounds
    }
    final func startAnimating() {
        self.viewNodata.startAnimating()
    }
    final func stopAnimating(count: Int) {
        self.viewNodata.z_datacount = count
    }
}
extension UITableView {
    
    final func addNoDataView(image: UIImage, text: String = "No Data", textColor: UIColor = "#FFFFFF".color, textSize: CGFloat = 18, imageY: CGFloat = 100) {
        self.viewNodata.z_imageicon.image = image
        self.viewNodata.z_lbtitle.text = text
        self.viewNodata.z_lbtitle.textColor = textColor
        self.viewNodata.z_lbtitle.fontSize = textSize
        let imagesize = self.viewNodata.z_imageicon.image?.size ?? CGSize.init(width: 10.scale, height: 10.scale)
        let imagey = imageY == 0 ? (self.height/2 - imagesize.height/2) : imageY
        self.viewNodata.z_imageicon.frame = CGRect.init(self.width/2 - imagesize.width/2, imagey, imagesize.width, imagesize.height)
        self.viewNodata.z_lbtitle.y = self.viewNodata.z_imageicon.y + self.viewNodata.z_imageicon.height + 15.scale
        self.backgroundView = self.viewNodata
        self.backgroundView?.frame = self.bounds
    }
    final func startAnimating() {
        self.viewNodata.startAnimating()
    }
    final func stopAnimating(count: Int) {
        self.viewNodata.z_datacount = count
    }
}
