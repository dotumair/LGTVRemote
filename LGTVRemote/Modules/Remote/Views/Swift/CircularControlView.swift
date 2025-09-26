
import UIKit
import WebOSClient

class CircularControlView: UIView {

    // MARK: - Properties
    
    private let centerButtonWidth: CGFloat = 100

    // The central "OK" button.
    private lazy var centerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 22.dp, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "353537")
        button.layer.shadowColor = UIColor(hex: "1584E9").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 1.0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // Views for the four directional segments.
    private var directionalViews: [UIView] = []

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        positionDirectionalViews() // Position the icons
        
        // Ensure the center button is circular after layout.
        centerButton.layer.cornerRadius = centerButton.bounds.width / 2
        
        layer.cornerRadius = self.bounds.width / 2
        
        layer.sublayers?.filter({$0.name == "CAShapeLayer"}).forEach({$0.removeFromSuperlayer()})
        addInnerShadow(to: self, color: UIColor.black.withAlphaComponent(0.9), opacity: 1.0, cornerRadius: bounds.width / 2)
    }

    // MARK: - Private Setup Methods

    /// Sets up the initial view hierarchy and layers.
    private func setupView() {
        // The main background of the view is clear, as the shape layers will provide the color.
        backgroundColor = UIColor(hex: "131313")

        addSubview(centerButton)
        
        // Define symbols and create views for each direction.
        // The order is important for angle calculations: Up, Right, Down, Left
        let symbols = ["chevron.up", "chevron.right", "chevron.down", "chevron.left"]
        for (index, symbolName) in symbols.enumerated() {
            let directionalView = createDirectionalView(symbolName: symbolName, tag: index)
            directionalViews.append(directionalView)
            addSubview(directionalView)
        }
        
        setupCenterButtonConstraints()
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

    /// Sets up the constraints for the central button.
    private func setupCenterButtonConstraints() {
        centerButton.addConstraints(centerX: .equalToSuperView(0), centerY: .equalToSuperView(0), width: .equalTo(100.dp), height: .equalTo(100.dp))
    }
    
    /// Positions the directional icon views within their respective segments.
    private func positionDirectionalViews() {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = bounds.width / 2
        let innerRadius = (centerButton.bounds.width / 2) + 20
        
        // The radius for the center of the icons
        let positionRadius = (outerRadius + innerRadius) / 2

        for (index, dView) in directionalViews.enumerated() {
            // Calculate angle based on index: 0=Up, 1=Right, 2=Down, 3=Left
            let angle = CGFloat(index) * .pi / 2 - .pi / 2
            
            let x = viewCenter.x + positionRadius * cos(angle)
            let y = viewCenter.y + positionRadius * sin(angle)
            
            // Set the size and position of the icon's container view
            dView.frame.size = CGSize(width: 44.dp, height: 44.dp)
            dView.center = CGPoint(x: x, y: y)
        }
    }

    /// Creates a tappable view for a single direction.
    private func createDirectionalView(symbolName: String, tag: Int) -> UIView {
        let view = UIView()
        // No autoresizing mask translation needed as we are setting the frame manually.
        view.tag = tag

        // Add the icon image
        let image = UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.dp, weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Center the icon within the view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(directionalTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }

    // MARK: - Actions

    /// Handles tap events for the directional views.
    @objc private func directionalTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        // Animate the press
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                view.alpha = 1.0
            }
        }
        
        if (0...3).contains(view.tag) {
            AppButtonsClickManager.shared.handleClick(for: ButtonsType.circular) {
                let keys: [WebOSKeyTarget] = [
                    .up, .right, .down, .left
                ]
                TVHelper.shared.sendCommand(keys[view.tag])
            } limitAction: {
                if let parent = self.parentViewController as? RemoteVC {
                    parent.buttonsLimitReached(for: ButtonsType.circular)
                }
            }
        }
    }
    
    /// Handles tap events for the center button.
    @objc private func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        AppButtonsClickManager.shared.handleClick(for: ButtonsType.circular) {
            TVHelper.shared.sendCommand(.enter)
        } limitAction: {
            if let parent = self.parentViewController as? RemoteVC {
                parent.buttonsLimitReached(for: ButtonsType.circular)
            }
        }
    }
    
    // This is crucial for making sure only the visible parts of the directional views are tappable.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If the touch is outside the main circle, ignore it.
        let outerPath = UIBezierPath(ovalIn: self.bounds)
        if !outerPath.contains(point) {
            return nil
        }
        
        // Check if the center button was hit.
        if let view = centerButton.hitTest(convert(point, to: centerButton), with: event) {
            return view
        }
        
        // Check if the touch is inside the inner circle (dead zone)
        let innerPath = UIBezierPath(ovalIn: centerButton.frame)
        if innerPath.contains(point) {
            return nil // It's not the center button, but it's in the middle, so it's a miss.
        }

        // Determine which quadrant was hit based on the angle from the center.
        let angle = atan2(point.y - bounds.midY, point.x - bounds.midX)
        
        var tappedView: UIView?

        if angle >= -3 * .pi / 4 && angle < -.pi / 4 {
            // UP (tag 0)
            tappedView = directionalViews.first { $0.tag == 0 }
        } else if angle >= -.pi / 4 && angle < .pi / 4 {
            // RIGHT (tag 1)
            tappedView = directionalViews.first { $0.tag == 1 }
        } else if angle >= .pi / 4 && angle < 3 * .pi / 4 {
            // DOWN (tag 2)
            tappedView = directionalViews.first { $0.tag == 2 }
        } else {
            // LEFT (tag 3)
            tappedView = directionalViews.first { $0.tag == 3 }
        }
        
        return tappedView
    }
}
