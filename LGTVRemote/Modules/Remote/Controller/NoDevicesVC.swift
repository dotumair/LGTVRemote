
import UIKit
import BottomPopup
import ProgressHUD
import Combine

class NoDevicesVC: BottomPopupViewController {
    
    override var popupHeight: CGFloat {
        return 600.dp
    }
    
    override var popupTopCornerRadius: CGFloat {
        return 30.dp
    }
    
    var isSearchingForTVs: Bool = false {
        didSet {
            if isSearchingForTVs {
                searchButton.setTitle("Stop Searching", for: .normal)
                searchButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
                view.viewWithTag(1212)?.isHidden = true
                collectionView.backgroundView = generateCollectionViewBackground()
            } else {
                searchButton.setTitle("Search Devices", for: .normal)
                searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
                if tvsFoundInSearch.isEmpty {
                    view.viewWithTag(1212)?.isHidden = false
                }
                collectionView.backgroundView = nil
            }
        }
    }
    
    var ssdpClient = SSDPDiscovery()
    var services: [SSDPService] = []
    var tvsFoundInSearch: [TVDevice] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Devices"
        label.textColor = .white
        label.font = UIFont.appFont(ofSize: 18.dp, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noDevice")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.text = "No devices connected?"
        label.textColor = .white
        label.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no TV device connected. Please link your TV Device to proceed."
        label.textColor = UIColor.white
        label.font = UIFont.appFont(ofSize: 14.dp)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search Devices", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "262626")
        button.titleLabel?.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        button.layer.cornerRadius = 28.dp
//        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addManuallyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Manually", for: .normal)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        button.layer.cornerRadius = 28.dp
//        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addManuallyTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "131313")

        // Create stack views for organization
        let centralContentStack = UIStackView(arrangedSubviews: [mainImageView, primaryLabel, secondaryLabel])
        centralContentStack.axis = .vertical
        centralContentStack.spacing = 16
        centralContentStack.alignment = .center
        centralContentStack.translatesAutoresizingMaskIntoConstraints = false
        centralContentStack.setCustomSpacing(1, after: primaryLabel)
        centralContentStack.isHidden = TVHelper.shared.isAnyDeviceConnected()
        centralContentStack.tag = 1212

        let buttonStack = UIStackView(arrangedSubviews: [searchButton, addManuallyButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        // Add all subviews
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(centralContentStack)
        view.addSubview(collectionView)
        view.addSubview(buttonStack)
        
        titleLabel.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 16), centerX: .equalToSuperView(0))
        
        closeButton.addConstraints(right: .equalToSuperView(-20), centerY: .equalToWithOffset(titleLabel.snp.centerY, 0))
        
        centralContentStack.addConstraints(left: .equalToSuperView(40), right: .equalToSuperView(-40), centerX: .equalToSuperView(0), centerY: .equalToSuperView(-40))
        
        mainImageView.addConstraints(height: .equalTo(120))
        
        buttonStack.addConstraints(left: .equalToSuperView(20), right: .equalToSuperView(-20), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, -10))
        
        collectionView.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 20), left: .equalToSuperView(30), right: .equalToSuperView(-30), bottom: .equalToWithOffset(buttonStack.snp.top, -20))
        
        searchButton.addConstraints(height: .equalTo(56.dp))
        addManuallyButton.addConstraints(height: .equalTo(56.dp))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if TVHelper.shared.isAnyDeviceConnected() {
                self.searchTapped()
            }
        }
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func searchTapped() {
        if isSearchingForTVs {
            services.removeAll()
            ssdpClient.stop()
        } else {
            services.removeAll()
            ssdpClient.delegate = self
            ssdpClient.discoverService()
        }
    }
    
    @objc func addManuallyTapped() {
//        if debugVariant {
//            tvsFoundInSearch.append(TV(id: "1212", name: "Default Device", type: "TV", uri: "127.0.0.1"))
//            collectionView.reloadData()
//            return
//        }
        let vc = ConnectManualVC()
        vc.connectionSuccessful = {
            self.dismiss(animated: true)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func stopSearchAndContinueMainScreen() {
        services.removeAll()
        ssdpClient.stop()
        self.dismiss(animated: true)
    }
}

extension NoDevicesVC: SSDPDiscoveryDelegate {
    func ssdpDiscoveryDidStart(_ discovery: SSDPDiscovery) {
        Task { @MainActor in
            isSearchingForTVs = true
        }
    }
    
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didDiscoverService service: SSDPService) {
        services.append(service)
    }
    
    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery) {
        Task { @MainActor in
            prepareServices()
            isSearchingForTVs = false
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
            ProgressHUD.failed("No TV Devices Found!")
        }
        services.removeAll()
    }
}

extension NoDevicesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

extension NoDevicesVC: TVCellDelegate {
    func tvCell(_ cell: TVCell, didTapConnectButtonFor tv: TVDevice) {
        if tv.host.isValidIPAddress {
            ProgressHUD.animate("Connecting...")
            TVHelper.shared.tryDeviceConnect(device: tv)
        }
    }
}
