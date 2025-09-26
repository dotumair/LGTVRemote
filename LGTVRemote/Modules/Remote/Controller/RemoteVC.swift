
import UIKit
import Combine

extension Int {
    var dp: CGFloat {
        CGFloat(self) * (UIDevice.isPad ? 1.3 : 1)
    }
}

class RemoteVC: UIViewController {
    
    // MARK: Constants
    private let controlViewTag: Int = 1212
    
    private var currentButtonTab: Int = 0
    
    private lazy var powerButton = createGradientButton(imageName: "power")
    private lazy var proButton = createGradientButton(imageName: "crown")
    
    private lazy var buttonsTabView: MainTabButtonsView = {
        let view = MainTabButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var volChannelView: VolumeChannelButtonView = {
        let view = VolumeChannelButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mediaControlView: MediaControlButtonView = {
        let view = MediaControlButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var controlView: CircularControlView = {
        let view = CircularControlView()
        view.tag = controlViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var touchView: TouchpadView = {
        let view = TouchpadView()
        view.tag = controlViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 20.dp
        view.clipsToBounds = true
        return view
    }()
    
//    private lazy var connectionIndicatorView: ConnectionIndicatorView = {
//        let view = ConnectionIndicatorView()
//        view.updateConnectionStatus(isConnected: false)
//        view.layer.cornerRadius = 8.dp
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        setupViews()
        setupViewActions()
        setupObservers()
    }
    
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
    
    private func setupViews() {
        let padding: CGFloat = 20.dp
        
        [powerButton, proButton, buttonsTabView, mediaControlView].forEach({view.addSubview($0)})
        
        powerButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 10), left: .equalToSuperView(padding), width: .equalTo(50.dp), height: .equalTo(50.dp))
        proButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 10), right: .equalToSuperView(-padding), width: .equalTo(50.dp), height: .equalTo(50.dp))
        proButton.isHidden = InAppService.shared.isProUser
        
//        connectionIndicatorView.addConstraints(centerX: .equalToSuperView(0), centerY: .equalToWithOffset(powerButton.snp.centerY, 0), height: .equalTo(50.dp))
        
        buttonsTabView.addConstraints(top: .equalToWithOffset(powerButton.snp.bottom, padding), left: .equalToSuperView(padding), right: .equalToSuperView(-padding), height: .equalTo(60.dp))
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        scrollView.delaysContentTouches = false
        
        if UIDevice.isPad {
            scrollView.addConstraints(top: .equalToWithOffset(buttonsTabView.snp.bottom, 50), left: .equalToSuperView(padding * 7), right: .equalToSuperView(-padding * 7), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0))
        } else {
            scrollView.addConstraints(top: .equalToWithOffset(buttonsTabView.snp.bottom, 25), left: .equalToSuperView(padding * 1.5), right: .equalToSuperView(-padding * 1.5), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0))
        }

        contentView.addConstraints(top: .equalToSuperView(0), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0), width: .equalToSuperView(0))
        
        contentView.addSubview(volChannelView)
        volChannelView.addConstraints(top: .equalToSuperView(0), left: .equalToSuperView(0), right: .equalToSuperView(0), height: .equalTo(200.dp + volChannelView.calculateButtonHeight()))
        
        contentView.addSubview(controlView)
        
        controlView.addConstraints(top: .equalToWithOffset(volChannelView.snp.bottom, 0), centerX: .equalToSuperView(0), width: .equalTo(250.dp), height: .equalTo(250.dp))
//        touchView.addConstraints(top: .equalToWithOffset(volChannelView.snp.bottom, padding * 1.5), left: .equalToSuperView(0), right: .equalToSuperView(0), height: .equalTo(200.dp))
        
        mediaControlView.addConstraints(top: .equalToWithOffset(volChannelView.snp.bottom, 280.dp), left: .equalToSuperView(20), right: .equalToSuperView(-20), bottom: .equalToWithOffset(contentView.snp.bottom, -padding * 1.5), height: .equalTo(40.dp))
        
        buttonsTabView.onTabSelected = { tab in
            if self.currentButtonTab != tab {
                self.currentButtonTab = tab
                contentView.subviews.first(where: {$0.tag == self.controlViewTag})?.removeFromSuperview()
                if tab == 0 {
                    contentView.addSubview(self.controlView)
                    self.controlView.addConstraints(top: .equalToWithOffset(self.volChannelView.snp.bottom, 0), centerX: .equalToSuperView(0), width: .equalTo(250.dp), height: .equalTo(250.dp))
                    self.mediaControlView.updateConstraints(top: .equalToWithOffset(self.volChannelView.snp.bottom, 280.dp))
                } else {
                    contentView.addSubview(self.touchView)
                    self.touchView.addConstraints(top: .equalToWithOffset(self.volChannelView.snp.bottom, padding * 1.5), left: .equalToSuperView(0), right: .equalToSuperView(0), height: .equalTo(200.dp))
                    self.mediaControlView.updateConstraints(top: .equalToWithOffset(self.volChannelView.snp.bottom, (200.dp) + (padding * 3.0)))
                }
            }
        }
    }
    
    func setupViewActions() {
        volChannelView.onViewAction = { action in
            switch action {
            case .tvCommand(let command):
                TVHelper.shared.sendCommand(command)
                break
            case .more:
                let vc = DialpadVC()
                self.present(vc, animated: true)
                break
            case .keyboard:
                if !InAppService.shared.isProUser {
                    return
                }
                let vc = KeyboardVC()
                self.present(vc, animated: true)
            }
        }
        
        powerButton.addTarget(self, action: #selector(powerButtonTapped), for: .touchUpInside)
        proButton.addTarget(self, action: #selector(proButtonTapped), for: .touchUpInside)
    }
    
    @objc func powerButtonTapped() {
//        TVHelper.shared.sendCommand(TVRemoteCommand.Params.ControlKey.powerToggle)
    }
    
    @objc func proButtonTapped() {
        presentInAppScreen()
    }
    
    private func createGradientButton(imageName: String) -> GradientButton {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let xmarkImage = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold))
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        return button
    }
    
    func buttonsLimitReached(for type: ButtonsType) {
        presentInAppScreen()
    }
}
