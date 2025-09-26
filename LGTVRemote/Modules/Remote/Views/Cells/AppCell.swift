
import UIKit

class AppCell: UICollectionViewCell {
    static let identifier = "AppCell"
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hex: "131313")
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        imageView.equalToSuperView(offsets: UIEdgeInsets(top: 25.dp, left: 25.dp, bottom: 25.dp, right: 25.dp))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with image: String) {
        imageView.image = UIImage(named: image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.sublayers?.filter({$0.name == "CAShapeLayer"}).forEach({$0.removeFromSuperlayer()})
        addInnerShadow(to: contentView, color: UIColor.black.withAlphaComponent(0.6), opacity: 1.0, cornerRadius: 20)
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
