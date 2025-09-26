
import UIKit
import Combine
import ProgressHUD

class MainTabBarVC: UITabBarController {
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor(hex: "141313")
        self.tabBar.tintColor = UIColor.foreground
        self.tabBar.barTintColor = UIColor.foreground
        
        TVHelper.shared.remoteStatusPublisher.receive(on: DispatchQueue.main).sink { result in
            switch result {
            case .disconnected:
                if let topViewController = UIApplication.topViewController() {
                    let vc = NoDevicesVC()
//                    vc.modalPresentationStyle = .fullScreen
                    topViewController.present(vc, animated: true)
                }
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        DispatchQueue.main.async {
//            self.presentInAppScreen()
            let vc = GuideConnectVC()
            if let topViewController = UIApplication.topViewController() {
//                topViewController.present(vc, animated: true)
            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                    .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                                    .first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
