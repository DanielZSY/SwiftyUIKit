
import UIKit

extension UIView {
    /// 添加自定义方向的圆角
    public func setRoundCorners(corners: UIRectCorner, radius: CGFloat, lineColor: UIColor? = nil, lineWidth: CGFloat = 1) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        if let scolor = lineColor {
            let templayer = CAShapeLayer()
            templayer.lineWidth = lineWidth
            templayer.fillColor = UIColor.clear.cgColor
            templayer.strokeColor = scolor.cgColor
            templayer.frame = self.bounds
            templayer.path = path.cgPath
            self.layer.addSublayer(templayer)
            
            let mask = CAShapeLayer.init(layer: templayer)
            mask.path = path.cgPath
            self.layer.mask = mask
        } else {
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
