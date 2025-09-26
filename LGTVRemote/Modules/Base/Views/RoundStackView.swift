
import UIKit

class RoundStackView: UIStackView {
    
    private let gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = UIColor(hex: "3E3E40") {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor(hex: "262629") {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var addInnerShadow: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width / 2
        
        gradientLayer.name = "CAGradient"
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.cornerRadius = self.bounds.width / 2

//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.sublayers?.filter({$0.name == "CAGradient" || $0.name == "CAShapeLayer"}).forEach({$0.removeFromSuperlayer()})
        layer.insertSublayer(gradientLayer, at: 0)
        
        if addInnerShadow {
            addInnerShadow(to: self, color: UIColor.white.withAlphaComponent(0.6), offset: CGSize(width: 0, height: 4), opacity: 1.0, cornerRadius: bounds.width / 2)
        }
    }
    
    private func addInnerShadow(to view: UIView,
                        color: UIColor = .black,
                        offset: CGSize = .zero,
                        radius: CGFloat = 5.0,
                        opacity: Float = 0.5,
                        cornerRadius: CGFloat = 0) {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.name = "CAShapeLayer"
        shadowLayer.frame = view.bounds

        // Create a larger path that surrounds the view
        let inset: CGFloat = -radius * 2
        let outerPath = UIBezierPath(roundedRect: view.bounds.insetBy(dx: inset, dy: inset), cornerRadius: cornerRadius)
        
        // Create a smaller path the size of the view (inner cutout)
        let innerPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
        
        // Append the inner path to the outer (reversed so it creates a "hole")
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true

        shadowLayer.path = outerPath.cgPath
        shadowLayer.fillRule = .evenOdd
        shadowLayer.fillColor = color.cgColor
        shadowLayer.opacity = opacity

        // Add blur using shadow properties
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOpacity = 1.0

        view.layer.addSublayer(shadowLayer)
    }
}
