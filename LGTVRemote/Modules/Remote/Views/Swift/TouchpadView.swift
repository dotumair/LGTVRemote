
import UIKit

class TouchpadView: UIView {
    
    private var viewWidth: CGFloat = 300
    private var viewHeight: CGFloat = 300
    private let divider: CGFloat = 12
    private let scrollThreshold: CGFloat = 13
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let unlockContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var panGesture: UIPanGestureRecognizer? = nil
    var tapGesture: UITapGestureRecognizer? = nil
    
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
        
        viewWidth = bounds.width
        viewHeight = bounds.height
        
        layer.cornerRadius = cornerRadius
        
        layer.sublayers?.filter({$0.name == "CAShapeLayer"}).forEach({$0.removeFromSuperlayer()})
        addInnerShadow(to: self, color: UIColor.black.withAlphaComponent(0.9), opacity: 1.0, cornerRadius: cornerRadius)
    }
    
    // MARK: - Private Setup Methods
    
    /// Sets up the initial view hierarchy and layers.
    private func setupView() {
        // The main background of the view is clear, as the shape layers will provide the color.
        backgroundColor = UIColor(hex: "131313")
        
        setupUnlockContentView()
        if InAppService.shared.isProUser {
            addGestureRecognizer()
        }
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseListener), name: InAppState.success, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseListener), name: InAppState.failed, object: nil)
    }
    
    @objc private func purchaseListener() {
        if InAppService.shared.isProUser {
            unlockContentView.isHidden = true
            addGestureRecognizer()
        } else {
            unlockContentView.isHidden = false
            removeGestureRecognizers()
        }
    }
    
    private func setupUnlockContentView() {
        let lockImageView = UIImageView()
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        // Using an SF Symbol for the lock icon
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        lockImageView.image = UIImage(systemName: "lock.fill", withConfiguration: config)
        lockImageView.tintColor = .white
        lockImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Unlock with Premium"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center

        let unlockButton = GradientButton(type: .system)
        unlockButton.addInnerShadow = false
        unlockButton.translatesAutoresizingMaskIntoConstraints = false
        unlockButton.setTitle("UNLOCK", for: .normal)
        unlockButton.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .medium)
        unlockButton.setTitleColor(.white, for: .normal)
        unlockButton.layer.cornerRadius = 22 // Half of the height for a perfect pill shape
        unlockButton.layer.masksToBounds = true
        unlockButton.addTarget(self, action: #selector(unlockButtonTapped), for: .touchUpInside)

        self.addSubview(unlockContentView)
        unlockContentView.equalToSuperView()
        
        [lockImageView, titleLabel, unlockButton].forEach({unlockContentView.addSubview($0)})
        
        titleLabel.addConstraints(centerX: .equalToSuperView(), centerY: .equalToSuperView())
        lockImageView.addConstraints(bottom: .equalToWithOffset(titleLabel.snp.top, -10), centerX: .equalToSuperView(), width: .equalTo(50), height: .equalTo(50))
        unlockButton.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 10), centerX: .equalToSuperView(), width: .equalTo(100), height: .equalTo(44))
        
        unlockContentView.isHidden = InAppService.shared.isProUser
    }
    
    private func addGestureRecognizer() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture!)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        addGestureRecognizer(tapGesture!)
    }
    
    private func removeGestureRecognizers() {
        if let gesture = panGesture {
            removeGestureRecognizer(gesture)
        }
        if let gesture = tapGesture {
            removeGestureRecognizer(gesture)
        }
    }
    
    @objc func unlockButtonTapped() {
        self.parentViewController?.presentInAppScreen()
    }
    
    @objc private func handleClick(_ sender: UITapGestureRecognizer) {
        TVHelper.shared.sendCommand(.click)
    }
    
    // The selector method that will be called when the gesture changes
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        // We only need to act when the gesture is actively changing.
        guard sender.state == .changed else { return }
        
        // Get the location of the touch within this view's coordinate space.
        let location = sender.location(in: self)

        // Calculate displacement from the center, same as your SwiftUI version.
        let dx = (location.x - viewWidth / 2) / divider
        let dy = (location.y - viewHeight / 2) / divider

        // Check if the vertical movement exceeds the scroll threshold.
        if dy > scrollThreshold {
            TVHelper.shared.sendCommand(.scroll(dx: 0, dy: -10))
        } else if dy < -scrollThreshold {
            TVHelper.shared.sendCommand(.scroll(dx: 0, dy: 10))
        } else {
            // Otherwise, send a standard move command.
            TVHelper.shared.sendCommand(.move(dx: Int(dx), dy: Int(dy)))
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
