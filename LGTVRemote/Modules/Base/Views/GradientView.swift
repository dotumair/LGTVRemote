
import UIKit

@IBDesignable
class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.green {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateGradient()
        }
    }

    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        
        gradientLayer.name = "CAGradient"
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.cornerRadius = cornerRadius

//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.sublayers?.filter({$0.name == "CAGradient"}).forEach({$0.removeFromSuperlayer()})
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
