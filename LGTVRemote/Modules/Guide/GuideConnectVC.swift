
import UIKit
import ProgressHUD
import Combine

class GuideConnectVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var tvConnectionsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "070B12")
        view.layer.cornerRadius = 20.dp
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.dp
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TVCell.self, forCellWithReuseIdentifier: TVCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Variables
    
    private var ssdpClient = SSDPDiscovery()
    private var services: [SSDPService] = []
    private var tvsFoundInSearch: [TVDevice] = []
    private var isViewVisible: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "0C111B")
        
        TVHelper.shared.connectionStatusPublisher.receive(on: DispatchQueue.main).sink { result in
            if result {
                ProgressHUD.succeed("Connection Successful")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.stopSearchAndContinueMainScreen()
                })
            } else {
                ProgressHUD.failed("Failed to connect")
            }
        }
        .store(in: &cancellables)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewVisible = false
    }

    private func setupViews() {
        let imageView = UIImageView(image: UIImage(named: "radial_bg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.equalToSuperView()
        
        let bars = PageBarsView()
        bars.translatesAutoresizingMaskIntoConstraints = false
        bars.currentPage = 1
        view.addSubview(bars)
        bars.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 20.dp), left: .equalToSuperView(50.dp), right: .equalToSuperView(-50.dp), height: .equalTo(6.dp))
        
        let titleLabel = createLabel(text: "Connect to your TV", textAlignment: .center, font: UIFont.appFont(ofSize: 22.dp, weight: .bold))
        view.addSubview(titleLabel)
        titleLabel.addConstraints(top: .equalToWithOffset(bars.snp.bottom, 30.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
        
        let subTitleLabel = createLabel(text: "Your TV must be turned on and connected to the same Wi-Fi network.", textColor: UIColor(hex: "ADADAD"), textAlignment: .center, font: UIFont.appFont(ofSize: 15.dp))
        view.addSubview(subTitleLabel)
        subTitleLabel.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 10.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
        
        let selectDeviceLabel = createLabel(text: " Select a TV", textAlignment: .left, font: UIFont.appFont(ofSize: 16.dp, weight: .medium))
        view.addSubview(selectDeviceLabel)
        selectDeviceLabel.addConstraints(top: .equalToWithOffset(subTitleLabel.snp.bottom, 20.dp), left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp))
        
        view.addSubview(tvConnectionsView)
        tvConnectionsView.addConstraints(top: .equalToWithOffset(selectDeviceLabel.snp.bottom, 10.dp), left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp))
        
        let notFindButton = UIButton(type: .system)
        notFindButton.translatesAutoresizingMaskIntoConstraints = false
        notFindButton.setTitle("Can’t find TV?", for: .normal)
        notFindButton.titleLabel?.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        notFindButton.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        notFindButton.setTitleColor(.white, for: .normal)
        notFindButton.layer.cornerRadius = 25.dp
        notFindButton.addTarget(self, action: #selector(cannotFindButtonTapped), for: .touchUpInside)
        view.addSubview(notFindButton)
        notFindButton.addConstraints(top: .equalToWithOffset(tvConnectionsView.snp.bottom, 20.dp), left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp), height: .equalTo(50.dp))

        let setupLaterButton = UIButton(type: .system)
        setupLaterButton.translatesAutoresizingMaskIntoConstraints = false
        setupLaterButton.setTitle("Setup Later", for: .normal)
        setupLaterButton.titleLabel?.font = UIFont.appFont(ofSize: 14.dp, weight: .medium)
        setupLaterButton.setTitleColor(UIColor(hex: "ADADAD"), for: .normal)
        setupLaterButton.addTarget(self, action: #selector(stopSearchAndContinueMainScreen), for: .touchUpInside)
        view.addSubview(setupLaterButton)
        setupLaterButton.addConstraints(top: .equalToWithOffset(notFindButton.snp.bottom, 10.dp), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0), centerX: .equalToSuperView(0))
        
        setupConnectionsView()
    }
    
    private func createLabel(text: String, textColor: UIColor = .white, textAlignment: NSTextAlignment, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = textAlignment
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        return label
    }
    
    private func setupConnectionsView() {
        tvConnectionsView.addSubview(collectionView)
        collectionView.addConstraints(top: .equalToSuperView(10.dp), left: .equalToSuperView(10.dp), right: .equalToSuperView(-10.dp))
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.white.withAlphaComponent(0.07)
        tvConnectionsView.addSubview(divider)
        divider.addConstraints(top: .equalToWithOffset(collectionView.snp.bottom, 10.dp), left: .equalToSuperView(10.dp), right: .equalToSuperView(-10.dp), height: .equalTo(2.dp))
        
        let addManualButton = UIButton(type: .system)
        addManualButton.translatesAutoresizingMaskIntoConstraints = false
        addManualButton.setTitle("  Connect Manually", for: .normal)
        addManualButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addManualButton.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        addManualButton.setTitleColor(.white, for: .normal)
        addManualButton.tintColor = UIColor.white
        addManualButton.addTarget(self, action: #selector(addManualButtonTapped), for: .touchUpInside)
        tvConnectionsView.addSubview(addManualButton)
        addManualButton.addConstraints(top: .equalToWithOffset(divider.snp.bottom, 0), left: .equalToSuperView(10.dp), right: .equalToSuperView(10.dp), bottom: .equalToSuperView(0), height: .equalTo(60.dp))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.services.removeAll()
            self.ssdpClient.delegate = self
            self.ssdpClient.discoverService()
        })
    }
    
    @objc private func cannotFindButtonTapped() {
        let vc = GuideHelpVC()
        present(vc, animated: true)
    }
    
    let delegate = PushTransitionStyle()
    @objc private func addManualButtonTapped() {
        self.services.removeAll()
        self.ssdpClient.stop()
        let vc = ConnectManualVC()
        vc.connectionSuccessful = {
            self.stopSearchAndContinueMainScreen()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = delegate
        present(vc, animated: true)
    }
    
    @objc private func stopSearchAndContinueMainScreen() {
        services.removeAll()
        ssdpClient.stop()
        self.navigationController?.removeControllerFromStack(AllowNetworkAccessVC.self)
        self.navigationController?.popViewController(animated: true)
    }
}

extension GuideConnectVC: SSDPDiscoveryDelegate {
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didDiscoverService service: SSDPService) {
        services.append(service)
    }
    
    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery) {
        Task { @MainActor in
            prepareServices()
        }
    }
    
    private func prepareServices() {
        for service in services {
            if let server = service.server,
               server.contains("TV"),
               let deviceName = service.deviceName,
               let mac = services.filter({
                   $0.host == service.host &&
                   $0.wakeup != nil
               })
                .first?
                .wakeup?
                .extractMacAddress() {
                let newDevice = TVDevice(id: UUID().uuidString, name: deviceName, host: service.host, mac: mac)
                if !tvsFoundInSearch.contains(newDevice) {
                    tvsFoundInSearch.append(newDevice)
                }
                collectionView.reloadData()
            }
        }
        if tvsFoundInSearch.isEmpty {
            if self.isViewVisible {
                ProgressHUD.failed("No TV Devices found.\nRetrying the search…")

                self.services.removeAll()
                self.ssdpClient.discoverService()
            }
        }
        services.removeAll()
    }

}

extension GuideConnectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = generateCollectionViewBackground()
        return tvsFoundInSearch.count
    }
    
    func generateCollectionViewBackground() -> UIView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        return spinner
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCell.reuseIdentifier, for: indexPath) as! TVCell
        cell.configure(with: tvsFoundInSearch[indexPath.item])
        cell.delegate = self
        return cell
    }
}

extension GuideConnectVC: TVCellDelegate {
    func tvCell(_ cell: TVCell, didTapConnectButtonFor tv: TVDevice) {
        if tv.host.isValidIPAddress {
            ProgressHUD.animate("Connecting...")
            TVHelper.shared.tryHostConnect(host: tv.host)
        }
    }
}
