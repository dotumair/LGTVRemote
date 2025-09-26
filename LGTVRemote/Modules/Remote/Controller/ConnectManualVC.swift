
import UIKit
import Combine
import ProgressHUD

class ConnectManualVC: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var connectionSuccessful: (() -> Void)?
    
    private lazy var ipAddressTextField: PaddingTextField = {
        let tf = PaddingTextField()
        tf.textPadding = UIEdgeInsets(top: 0, left: 20.dp, bottom: 0, right: 20.dp)
        tf.attributedPlaceholder = NSMutableAttributedString(string: "Type here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.9)])
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.cornerRadius = 25.dp
        tf.tintColor = .white
        tf.keyboardType = .numbersAndPunctuation
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        TVHelper.shared.connectionStatusPublisher.receive(on: DispatchQueue.main).sink { result in
            if result {
                ProgressHUD.succeed("Connection Successful")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dismiss(animated: true) {
                        self.connectionSuccessful?()
                    }
                })
            } else {
                ProgressHUD.failed("Failed to connect")
            }
        }
        .store(in: &cancellables)
//        
//        TVHelper.shared.remoteStatusPublisher.receive(on: DispatchQueue.main).sink { status in
//            switch status {
//            case .authorized:
//                self.dismiss(animated: true) {
//                    self.connectionSuccessful?()
//                }
//                break
//            case .unauthorized:
//                self.showAlert(message: "The app isn’t authorized to send commands to your TV.\nPlease Authorize the app after prompted on TV.")
//                break
//            default:
//                break
//            }
//        }
//        .store(in: &cancellables)
    }

    func setupViews() {
        let padding = 20.dp
        
        view.backgroundColor = UIColor.background

        let screenTitleLabel = UILabel()
        screenTitleLabel.text = "Manual Device Setup"
        screenTitleLabel.textColor = .white
        screenTitleLabel.font = UIFont.appFont(ofSize: 20.dp, weight: .bold)
        screenTitleLabel.textAlignment = .center
        screenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenTitleLabel)

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)

        let imageView = UIImageView()
//        imageView.backgroundColor = .random
        imageView.image = UIImage(named: "manualAddTV")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.text = "Find your device IP address:"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.appFont(ofSize: 18.dp, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let instructionsLabel = UILabel()
        instructionsLabel.text = """
        1. Hit Home on the remote.
        2. Go to Settings > General > Network.
        3. Connect to Wi-Fi if not already.
        4. Select Network Status > IP Settings.
        5. Enter IP address to connect:
        """
        instructionsLabel.textColor = .white
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let fullText = "1. Hit Home on the remote.\n2. Go to Settings > General > Network\n3. Connect to Wi-Fi if not already.\n4. Select Network Status > IP Settings.\n5. Enter IP Address to connect."
        let wordsToHighlight = ["Home", "Settings", "General", "Network", "IP Settings.", "IP Address"]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left

        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )

        for word in wordsToHighlight {
            if let range = fullText.range(of: word) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttribute(.foregroundColor, value: UIColor.foreground, range: nsRange)
            }
        }

        instructionsLabel.attributedText = attributedString
        view.addSubview(instructionsLabel)
        
//        let nameLabel = UILabel()
//        nameLabel.text = "Device Name"
//        nameLabel.textColor = .white
//        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nameLabel)
        
//        let nameTextField = PaddingTextField()
//        nameTextField.textPadding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        nameTextField.attributedPlaceholder = NSMutableAttributedString(string: "Type here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.9)])
//        nameTextField.borderStyle = .none
//        nameTextField.backgroundColor = .clear
//        nameTextField.layer.borderWidth = 2
//        nameTextField.layer.borderColor = UIColor.white.cgColor
//        nameTextField.layer.cornerRadius = 25
//        nameTextField.tintColor = .white
//        nameTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nameTextField)

        let ipAddressLabel = UILabel()
        ipAddressLabel.text = "IP Address"
        ipAddressLabel.textColor = .white
        ipAddressLabel.font = UIFont.appFont(ofSize: 16.dp, weight: .semibold)
        ipAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ipAddressLabel)

        view.addSubview(ipAddressTextField)

        let connectButton = UIButton(type: .system)
        connectButton.setTitle("CONNECT", for: .normal)
        connectButton.setTitleColor(.black, for: .normal)
        connectButton.backgroundColor = UIColor.white
        connectButton.layer.cornerRadius = 28.dp
        connectButton.titleLabel?.font = UIFont.appFont(ofSize: 20.dp, weight: .medium)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        view.addSubview(connectButton)
        
        screenTitleLabel.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 10), centerX: .equalToSuperView(0), height: .equalTo(padding * 2.0))
        backButton.addConstraints(left: .equalToSuperView(padding), centerY: .equalToWithOffset(screenTitleLabel.snp.centerY, 0))
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(screenTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
//            make.height.equalTo(view.snp.width).multipliedBy(0.85)
        }
        
        titleLabel.addConstraints(top: .equalToWithOffset(imageView.snp.bottom, padding), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5), height: .equalTo(padding * 2.0))
        
        instructionsLabel.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 10), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5))
        
//        nameLabel.addConstraints(left: .equalToSuperView(padding * 2.0))
//        nameTextField.addConstraints(top: .equalToWithOffset(nameLabel.snp.bottom, 10), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5), height: .equalTo(50.dp))
        
        ipAddressLabel.addConstraints(top: .equalToWithOffset(instructionsLabel.snp.bottom, padding), left: .equalToSuperView(padding * 2.0))
        ipAddressTextField.addConstraints(top: .equalToWithOffset(ipAddressLabel.snp.bottom, 10), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5), height: .equalTo(50.dp))
        
        connectButton.addConstraints(top: .equalToWithOffset(ipAddressTextField.snp.bottom, padding), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, -padding), height: .equalTo(56.dp))
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func connectButtonTapped() {
        ProgressHUD.animate("Connecting...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            let ip = self.ipAddressTextField.text ?? ""
            if ip.isValidIPAddress {
                TVHelper.shared.tryHostConnect(host: ip)
            } else {
                ProgressHUD.failed("Invalid IP Address")
            }
        })
    }
}
