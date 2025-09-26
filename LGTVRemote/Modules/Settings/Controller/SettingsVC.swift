
import UIKit
import MessageUI
import ProgressHUD
import SwiftUI

enum SettingType: String, CaseIterable {
    case connect
    case vibration
    case help
    case share
    case support
}

extension SettingType {
    var title: String {
        switch self {
        case .connect:
            return "Connect to a TV Device"
        case .vibration:
            return "Vibration"
        case .help:
            return "Help"
        case .share:
            return "Share App"
        case .support:
            return "Contact Support"
        }
    }
    
    var image: String {
        switch self {
        case .connect:
            return "tvIcon"
        case .vibration:
            return "vibrationIcon"
        case .help:
            return "supportIcon"
        case .share:
            return "shareIcon"
        case .support:
            return "supportIcon"
        }
    }
}

class SettingsVC: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont(ofSize: 20.dp, weight: .semibold)
        label.text = "Settings"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
   
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        titleLabel.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 0), left: .equalToSuperView(0), right: .equalToSuperView(0), height: .equalTo(44))
        
        //to prevent collection view cells color going to tabbar
        let placeholderView = UIView()
        placeholderView.backgroundColor = .clear
        view.addSubview(placeholderView)
        placeholderView.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0), height: .equalTo(1))

        view.addSubview(collectionView)
        collectionView.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 1), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToWithOffset(placeholderView.snp.top, -20))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SettingsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = collectionView.frame.width
        return CGSize(width: dimen, height: 80.dp)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = SettingType.allCases[indexPath.item]
        switch type {
        case .connect:
            if let topViewController = UIApplication.topViewController() {
                let vc = NoDevicesVC()
                topViewController.present(vc, animated: true)
            }
            break
        case .vibration:
            let value = UserDefaults.standard.vibrationEnabled
            UserDefaults.standard.vibrationEnabled = !value
            collectionView.reloadData()
            break
        case .help:
            let vc = UIHostingController(rootView: FAQView())
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .share:
            if let cell = collectionView.cellForItem(at: indexPath) {
                shareAppLink(cell)
            }
            break
        case .support:
            sendSupportMail()
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        cell.setupCell(with: SettingType.allCases[indexPath.item])
        return cell
    }
    
    private func shareAppLink(_ sender: UIView) {
        let appURL = URL(string: "https://apps.apple.com/app/id\(URLs.id)")!
        let vc = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // For iPad: Specify popover location
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(vc, animated: true)
    }
    
    private func sendSupportMail() {
        guard MFMailComposeViewController.canSendMail() else {
            ProgressHUD.banner("Mail Not Configured", "Please configure a mail account in the Mail app to send support emails.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                ProgressHUD.bannerHide()
            }
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.setToRecipients([URLs.support])
        composeVC.setSubject("\(URLs.name) | iOS")
        composeVC.setMessageBody("Your message: \n", isHTML: false)
        present(composeVC, animated: true)
    }
}
