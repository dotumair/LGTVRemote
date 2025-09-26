
import UIKit
import Network
import ProgressHUD

class AllowNetworkAccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "0C111B")
        
        setupViews()
    }
    
    private func setupViews() {
        let imageView = UIImageView(image: UIImage(named: UIDevice.isPad ? "allow_access_bg_ipad" :  "allow_access_bg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.equalToSuperView()
        
        let bars = PageBarsView()
        bars.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bars)
        bars.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 20.dp), left: .equalToSuperView(50.dp), right: .equalToSuperView(-50.dp), height: .equalTo(6.dp))
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Allow Local Network Access"
        titleLabel.font = UIFont.appFont(ofSize: 22.dp, weight: .bold)
        view.addSubview(titleLabel)
        titleLabel.addConstraints(top: .equalToWithOffset(bars.snp.bottom, 30.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
        
        let subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = "Our app can only send commands to your TV through a wireless network. Therefore, the app needs access to your home network to detect and connect to your TV."
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = UIFont.appFont(ofSize: 15.dp)
        subTitleLabel.textColor = UIColor(hex: "#ADADAD")
        view.addSubview(subTitleLabel)
        subTitleLabel.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 10.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
        
        let image = UIImageView(image: UIImage(named: "allowPermissionPopup"))
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.addConstraints(top: .equalToWithOffset(subTitleLabel.snp.bottom, 25.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
        
        let continueButton = GradientButton(type: .system)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.startColor = UIColor(hex: "70B9FD")
        continueButton.endColor = UIColor(hex: "1584E9")
        continueButton.addInnerShadow = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.appFont(ofSize: 18.dp, weight: .medium)
        continueButton.backgroundColor = .clear
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 25.dp
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.addConstraints(top: .equalToWithOffset(image.snp.bottom, 25.dp), left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, -40.dp), height: .equalTo(50.dp))
    }
    
    @objc func continueButtonTapped() {
        ProgressHUD.animate()
        
        Task {
            do {
                let status = try await requestLocalNetworkAuthorization()
                await MainActor.run {
                    ProgressHUD.dismiss()
                    if status {
                        let vc = GuideConnectVC()
                        self.navigationController?.pushViewController(vc, animated: false)
                    } else {
                        self.openAppSettings()
                    }
                }
            } catch {
                await MainActor.run {
                    ProgressHUD.dismiss()
                    openAppSettings()
                }
            }
        }
    }
    
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
