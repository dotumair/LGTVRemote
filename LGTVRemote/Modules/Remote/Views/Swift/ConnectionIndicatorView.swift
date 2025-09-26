
import UIKit

class ConnectionIndicatorView: UIView {

    // MARK: - Views
    
    private let statusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white // Icon color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup Methods

    private func setupView() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true

        // Add subviews
        addSubview(statusIconImageView)
        addSubview(statusLabel)
        
//        statusIconImageView.equalToSuperView(offsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        statusIconImageView.addConstraints(top: .equalToSuperView(4), centerX: .equalToSuperView(0), width: .equalTo(20.dp), height: .equalTo(20.dp))
        statusLabel.addConstraints(top: .equalToWithOffset(statusIconImageView.snp.bottom, 4), left: .equalToSuperView(6), right: .equalToSuperView(-6), bottom: .equalToSuperView(-4))
    }

    // MARK: - Public Methods

    /// Updates the connection status displayed in the status bar.
    /// - Parameter isConnected: A boolean indicating the current connection status.
    func updateConnectionStatus(isConnected: Bool) {
        if isConnected {
            backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0) // Bright green
            statusIconImageView.image = UIImage(systemName: "wifi") // Wi-Fi icon
            statusLabel.text = "Connected"
        } else {
            backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0) // Soft red
            statusIconImageView.image = UIImage(systemName: "link") // Broken chain link icon
            statusLabel.text = "Disconnected"
        }
    }
}
