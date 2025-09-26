
import UIKit
import StoreKit
import ProgressHUD
import BottomPopup

class TrialPurchaseScreen: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofSize: 28.dp, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: "How your", attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        let secondString = NSAttributedString(string: "\nfree trial works", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.foreground
        ])
        attributedString.append(secondString)
        label.attributedText = attributedString
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Try 3 Days Free, then $39.99/Year"
        label.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private let stepsView: TrialStepsView = {
        let view = TrialStepsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bottomView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(hex: "131313")
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15.dp
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InAppStepsCell.self, forCellWithReuseIdentifier: InAppStepsCell.identifier)
        collectionView.register(InAppExperienceCell.self, forCellWithReuseIdentifier: InAppExperienceCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background

        setupTopBarViews()
        setupBottomView()
        setupSteps()
        
        if let sub = InAppService.shared.getProduct(with: InAppItem.yearly) {
            displayPrice(of: sub)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(purchasesLoaded), name: InAppState.loaded, object: nil)
            InAppService.shared.load()
        }
    }
    
    @objc private func purchasesLoaded() {
        if let product = InAppService.shared.getProduct(with: InAppItem.yearly) {
            self.displayPrice(of: product)
        }
    }
    
    private func displayPrice(of product: Product) {
        let trial = InAppService.shared.getTrialDays(for: InAppItem.yearly)
        if trial.isEmpty {
            priceLabel.text = "\(product.displayPrice)/Year"
        } else {
            priceLabel.text = trial
        }
    }
    
    private func setupTopBarViews() {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: configuration)
        closeButton.setImage(xmarkImage, for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.clear
        closeButton.layer.cornerRadius = 10
        closeButton.layer.borderWidth = 1.0
        closeButton.layer.borderColor = UIColor(hex: "242426").cgColor
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        let restoreButton = UIButton(type: .system)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.setTitle("Restore Purchase", for: .normal)
        restoreButton.setTitleColor(.white, for: .normal) // Text color
        restoreButton.backgroundColor = UIColor.clear
        restoreButton.layer.cornerRadius = 10 // Rounded corners
        restoreButton.layer.borderWidth = 1.0
        restoreButton.layer.borderColor = UIColor(hex: "242426").cgColor
        restoreButton.clipsToBounds = true
        restoreButton.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        restoreButton.addTarget(self, action: #selector(restorePurchaseButtonTapped), for: .touchUpInside)
        view.addSubview(restoreButton)
        
        view.addSubview(titleLabel)
        
        closeButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top,UIDevice.isPad ? 20 : 5), left: .equalToSuperView(16), width: .equalTo(40.dp), height: .equalTo(40.dp))
        restoreButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top,UIDevice.isPad ? 20 : 5), right: .equalToSuperView(-16), width: .equalTo(160.dp), height: .equalTo(40.dp))
        
        titleLabel.addConstraints(top: .equalToWithOffset(restoreButton.snp.bottom, 10.dp), left: .equalToSuperView(0), right: .equalToSuperView(0))
    }
    
    private func setupSteps() {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsVerticalScrollIndicator = false
//        view.addSubview(scrollView)
        
        view.addSubview(collectionView)
        
        collectionView.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 20.dp), left: .equalToSuperView(UIDevice.isPad ? 50 : 20), right: .equalToSuperView(UIDevice.isPad ? -50 : -20), bottom: .equalToWithOffset(bottomView.snp.top, -0))
        
//        scrollView.addSubview(stepsView)

//        stepsView.addConstraints(top: .equalToSuperView(0), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0), width: .equalToSuperView(0))
    }
    
    private func setupBottomView() {
        let padding = 20.dp
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "No Commitment, Cancel Anytime"
        subtitleLabel.font = UIFont.appFont(ofSize: 14.dp, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "757575")
        subtitleLabel.textAlignment = .center
        
        let startTrialButton = UIButton(type: .system)
        startTrialButton.translatesAutoresizingMaskIntoConstraints = false
        startTrialButton.setTitle("Start Free Trial", for: .normal)
        startTrialButton.titleLabel?.font = UIFont.appFont(ofSize: 24.dp, weight: .semibold)
        startTrialButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startTrialButton.titleLabel?.minimumScaleFactor = 0.4
        startTrialButton.titleLabel?.lineBreakMode = .byClipping
        startTrialButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12.dp, bottom: 0, right: 12.dp)
        startTrialButton.setTitleColor(.white, for: .normal)
        startTrialButton.backgroundColor = UIColor.foreground
        startTrialButton.layer.cornerRadius = 30.dp
        startTrialButton.clipsToBounds = true
        startTrialButton.addTarget(self, action: #selector(startTrialButtonTapped), for: .touchUpInside)
        
        let viewAllButton = UIButton(type: .system)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.setTitle("View All Plans", for: .normal)
        viewAllButton.setTitleColor(UIColor.white, for: .normal)
        viewAllButton.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .semibold)
        viewAllButton.addTarget(self, action: #selector(viewAllPlansTapped), for: .touchUpInside)
        
        let privacyButton = UIButton(type: .system)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(UIColor.white, for: .normal)
        privacyButton.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .regular)
        privacyButton.addTarget(self, action: #selector(privacyPolicyTapped), for: .touchUpInside)
        
        let termsButton = UIButton(type: .system)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        termsButton.setTitle("Terms of Service", for: .normal)
        termsButton.setTitleColor(UIColor.white, for: .normal)
        termsButton.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .regular)
        termsButton.addTarget(self, action: #selector(termsOfServiceTapped), for: .touchUpInside)
        
        // Horizontal Stack View for Privacy Policy and Terms of Service
        let linksStackView = UIStackView(arrangedSubviews: [privacyButton, termsButton])
        linksStackView.translatesAutoresizingMaskIntoConstraints = false
        linksStackView.axis = .horizontal
        linksStackView.distribution = .fillEqually
        
        [priceLabel, subtitleLabel, startTrialButton, viewAllButton, linksStackView].forEach({bottomView.addSubview($0)})
        
        priceLabel.addConstraints(top: .equalToSuperView(padding / 2), left: .equalToSuperView(padding), right: .equalToSuperView(-padding))
        subtitleLabel.addConstraints(top: .equalToWithOffset(priceLabel.snp.bottom, 4.dp), left: .equalToSuperView(padding), right: .equalToSuperView(-padding))
        startTrialButton.addConstraints(top: .equalToWithOffset(subtitleLabel.snp.bottom, 15.dp), left: .equalToSuperView(padding), right: .equalToSuperView(-padding), height: .equalTo(60.dp))
        viewAllButton.addConstraints(top: .equalToWithOffset(startTrialButton.snp.bottom, 4.dp), left: .equalToSuperView(padding), right: .equalToSuperView(-padding))
        linksStackView.addConstraints(left: .equalToSuperView(padding), right: .equalToSuperView(-padding), bottom: .equalToSuperView(-padding))
        
        view.addSubview(bottomView)
        bottomView.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0), height: .equalTo(230.dp))
    }
    
    // MARK: - Button Actions
    
    @objc private func closeButtonTapped() {
        dismissController()
    }
    
    @objc private func restorePurchaseButtonTapped() {
        guard InAppService.shared.productsLoaded else { return }
        ProgressHUD.animate("Please wait")
        InAppService.shared.restore { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_:):
                    ProgressHUD.succeed("Restore Successful")
                    self.dismissController()
                    break
                case .failure(let error):
                    ProgressHUD.failed(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc private func startTrialButtonTapped() {
        #if DEBUG
        InAppService.shared.mockPurchase()
        self.dismissController()
        return
        #endif
        ProgressHUD.animate("Please wait...")
        InAppService.shared.buy(id: InAppItem.yearly) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_:):
                    ProgressHUD.succeed()
                    self.dismissController()
                    break
                case .failure(let error):
                    ProgressHUD.failed(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc private func viewAllPlansTapped() {
//        let vc = SubscriptionPopupVC()
//        vc.popupDelegate = self
//        self.present(vc, animated: true)
    }
    
    @objc private func privacyPolicyTapped() {
        if let url = URL(string: URLs.privacy) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func termsOfServiceTapped() {
        if let url = URL(string: URLs.terms) {
            UIApplication.shared.open(url)
        }
    }
    
    func dismissController() {
        self.dismiss(animated: true)
    }
}

extension TrialPurchaseScreen: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        if InAppService.shared.isProUser {
            self.dismiss(animated: true)
        }
    }
}

extension TrialPurchaseScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: 320.dp)
        }
        return CGSize(width: collectionView.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InAppStepsCell.identifier, for: indexPath) as! InAppStepsCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InAppExperienceCell.identifier, for: indexPath) as! InAppExperienceCell
            return cell
        }
    }
}
