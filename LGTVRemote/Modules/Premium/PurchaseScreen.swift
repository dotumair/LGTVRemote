
import UIKit
import BottomPopup
import StoreKit
import ProgressHUD

class PurchaseScreen: UIViewController {
  
    var selectedPurchase: InAppItem = .weekly

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofSize: 24.dp, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .left

        let attributedString = NSMutableAttributedString(string: "Clean your E-mail inbox faster \nwith", attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        let secondString = NSAttributedString(string: " AI Premium", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.foreground
        ])
        attributedString.append(secondString)
        label.attributedText = attributedString
        
        return label
    }()
    
    private lazy var enableTrialView: TrialSwitchView = {
        let view = TrialSwitchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.dp
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
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
        collectionView.register(PlanCell.self, forCellWithReuseIdentifier: PlanCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 24.dp, weight: .semibold)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.4
        button.titleLabel?.lineBreakMode = .byClipping
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12.dp, bottom: 0, right: 12.dp)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.foreground
        button.layer.cornerRadius = 30.dp
        button.clipsToBounds = true
        return button
    }()
    
//    private let stepsView: ListStepsView = {
//        let view = ListStepsView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        return view
//    }()
    
    private lazy var bottomView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background

        setupTopBarViews()
        setupBottomView()
        setupPlans()
    }

    private func setupTopBarViews() {
        let iconImageView = UIImageView(image: nil)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        view.addSubview(iconImageView)

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
        
        restoreButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top,UIDevice.isPad ? 20 : 5), right: .equalToSuperView(-16), width: .equalTo(160.dp), height: .equalTo(40.dp))
        
        view.addSubview(titleLabel)
        view.addSubview(enableTrialView)
        
        iconImageView.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 0), left: .equalToSuperView(50), right: .equalToSuperView(-50), height: .equalTo(200.dp))

        closeButton.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 5), left: .equalToSuperView(16), width: .equalTo(40.dp), height: .equalTo(40.dp))

        titleLabel.addConstraints(top: .equalToWithOffset(iconImageView.snp.bottom, 10.dp), left: .equalToSuperView(20), right: .equalToSuperView(-20))
        
        enableTrialView.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 20), left: .equalToSuperView(20), right: .equalToSuperView(-20), height: .equalTo(60.dp))
    }
    
    private func setupPlans() {
        view.addSubview(collectionView)
        collectionView.addConstraints(top: .equalToWithOffset(enableTrialView.snp.bottom, 20), left: .equalToSuperView(20), right: .equalToSuperView(-20), bottom: .equalToWithOffset(bottomView.snp.top, -10))
        collectionView.reloadData()
    }
    
    private func setupBottomView() {
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
        privacyButton.titleLabel?.font = UIFont.appFont(ofSize: 14.dp, weight: .regular)
        privacyButton.addTarget(self, action: #selector(privacyPolicyTapped), for: .touchUpInside)
        
        let termsButton = UIButton(type: .system)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        termsButton.setTitle("Terms of Service", for: .normal)
        termsButton.setTitleColor(UIColor.white, for: .normal)
        termsButton.titleLabel?.font = UIFont.appFont(ofSize: 14.dp, weight: .regular)
        termsButton.addTarget(self, action: #selector(termsOfServiceTapped), for: .touchUpInside)

        // Horizontal Stack View for Privacy Policy and Terms of Service
        let linksStackView = UIStackView(arrangedSubviews: [privacyButton, termsButton])
        linksStackView.translatesAutoresizingMaskIntoConstraints = false
        linksStackView.axis = .horizontal
        linksStackView.distribution = .fillEqually
        
        [continueButton, viewAllButton, linksStackView].forEach({bottomView.addSubview($0)})
        
        continueButton.addConstraints(top: .equalToSuperView(0), left: .equalToSuperView(20), right: .equalToSuperView(-20), height: .equalTo(60.dp))
        viewAllButton.addConstraints(top: .equalToWithOffset(continueButton.snp.bottom, 4), left: .equalToSuperView(20), right: .equalToSuperView(-20))
        linksStackView.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(-0), bottom: .equalToSuperView(-20))
        
        view.addSubview(bottomView)
        bottomView.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0), height: .equalTo(155.dp))
        
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        enableTrialView.action = { [weak self] isEnabled in
            guard let self = self else { return }
            if isEnabled {
                selectedPurchase = .yearly
            } else {
                selectedPurchase = .weekly
            }
            collectionView.reloadData()
            updateContinuButtonText()
        }
    }
    // MARK: - Button Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func restorePurchaseButtonTapped() {
        guard InAppService.shared.productsLoaded else { return }
        ProgressHUD.animate("Please wait")
        InAppService.shared.restore { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_:):
                    ProgressHUD.succeed("Restore Successful")
                    self.dismiss(animated: true)
                    break
                case .failure(let error):
                    ProgressHUD.failed(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc private func continueTapped() {
        ProgressHUD.animate("Please Wait")
        InAppService.shared.buy(id: selectedPurchase) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    ProgressHUD.succeed()
                    self.dismiss(animated: true)
                }
                break
            case .failure(let failure):
                ProgressHUD.failed(failure.localizedDescription)
                break
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
    
    func updateContinuButtonText() {
        let trial = InAppService.shared.getTrialDays(for: selectedPurchase)
        if trial.isEmpty {
            enableTrialView.enableSwitch.isOn = false
            continueButton.setTitle("Continue", for: .normal)
        } else {
            enableTrialView.enableSwitch.isOn = true
            continueButton.setTitle(trial, for: .normal)
        }
    }
}

extension PurchaseScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InAppItem.trialPurchases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60.dp)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPurchase = InAppItem.trialPurchases[indexPath.item]
        updateContinuButtonText()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanCell.identifier, for: indexPath) as! PlanCell
        let purchase = InAppItem.trialPurchases[indexPath.item]
        cell.setupCell(with: purchase, isSelected: purchase == selectedPurchase)
        return cell
    }
}

extension PurchaseScreen: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        if InAppService.shared.isProUser {
            self.dismiss(animated: true)
        }
    }
}
