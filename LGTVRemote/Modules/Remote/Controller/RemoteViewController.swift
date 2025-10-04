
import UIKit
import SwiftUI

final class RemoteViewController: UIViewController {
    
    private lazy var powerButton = createGradientButton(imageName: "power")
    private lazy var proButton = createGradientButton(imageName: "crown")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        setupLayout()
        setupObservers()
    }

    // MARK: - UI Setup

    private func setupLayout() {
        
        let padding: CGFloat = 20.dp
        
        [powerButton, proButton].forEach({view.addSubview($0)})
        
        powerButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 10), left: .equalToSuperView(padding), width: .equalTo(50.dp), height: .equalTo(50.dp))
        proButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 10), right: .equalToSuperView(-padding), width: .equalTo(50.dp), height: .equalTo(50.dp))
        proButton.isHidden = InAppService.shared.isProUser
        
        // 1. Create the actions struct with closures pointing to handler methods.
        let remoteActions = RemoteView.Actions(
            onPower: handlePower,
            onConnectDevice: handleConnectDevice,
            onBack: { self.handleButtonTap("Back") },
            onHome: { self.handleButtonTap("Home") },
            onMute: { self.handleButtonTap("Mute") },
            onKeyboard: {
                if !InAppService.shared.isProUser {
                    return
                }
                let vc = KeyboardVC()
                self.present(vc, animated: true)
            },
            onDialPad: {
                let vc = DialpadVC()
                self.present(vc, animated: true)
            },
            onMenu: { self.handleButtonTap("Menu") },
            onRewind: { self.handleButtonTap("Rewind") },
            onPlay: { self.handleButtonTap("Play") },
            onForward: { self.handleButtonTap("Forward") },
            onChannelDown: { self.handleButtonTap("Channel Down") },
            onChannelUp: { self.handleButtonTap("Channel Up") },
            onVolumeDown: { self.handleButtonTap("Volume Down") },
            onVolumeUp: { self.handleButtonTap("Volume Up") },
            onOK: { self.handleButtonTap("OK") },
            onUp: { self.handleDirectionalTap("Up") },
            onDown: { self.handleDirectionalTap("Down") },
            onLeft: { self.handleDirectionalTap("Left") },
            onRight: { self.handleDirectionalTap("Right") },
        )

        // 2. Create the SwiftUI view and pass the actions to it.
        let remoteView = RemoteView(actions: remoteActions)

        // 3. Use a UIHostingController to embed the SwiftUI view.
        let hostingController = UIHostingController(rootView: remoteView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // 4. Set up constraints for the hosting controller's view.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 70.dp), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0))
    }

    // MARK: - Action Handlers
    
    private func setupObservers() {
//        TVHelper.shared.connectionStatusPublisher.receive(on: DispatchQueue.main).sink { result in
//            self.connectionIndicatorView.updateConnectionStatus(isConnected: result)
//        }
//        .store(in: &cancellables)
    
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseListener), name: InAppState.success, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseListener), name: InAppState.failed, object: nil)
    }
    
    @objc func purchaseListener() {
        proButton.isHidden = InAppService.shared.isProUser
    }

    private func handlePower() {
        // Implement power button logic (e.g., API call)
        print("ViewController received: Power button tapped")
    }

    private func handleConnectDevice() {
        // Implement connect device logic (e.g., show a connection sheet)
        print("ViewController received: Connect Device tapped")
    }

    private func handleButtonTap(_ buttonName: String) {
        // Generic handler for most remote buttons
        print("ViewController received: \(buttonName) tapped")
    }
    
    private func handleDirectionalTap(_ direction: String) {
        // Handler for D-Pad arrows
        print("ViewController received: D-Pad \(direction) tapped")
    }
    
    private func createGradientButton(imageName: String) -> GradientButton {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let xmarkImage = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold))
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.addInnerShadow = false
        return button
    }
}

