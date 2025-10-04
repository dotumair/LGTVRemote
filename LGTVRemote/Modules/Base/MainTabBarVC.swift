
import UIKit
import Combine
import ProgressHUD

class MainTabBarVC: UITabBarController {
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let vc = SelectRemoteVC()
            if let topViewController = UIApplication.topViewController() {
//                topViewController.present(vc, animated: true)
            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        setupTabbar()
    }
    
    private func setupTabbar() {
        guard let controllers = self.viewControllers else { return }
        controllers[0].tabBarItem.image = UIImage(named: "ic_remote_tab")?.withRenderingMode(.alwaysOriginal)
        controllers[0].tabBarItem.selectedImage = UIImage(named: "ic_remote_tab_sl")?.withRenderingMode(.alwaysOriginal)
        controllers[1].tabBarItem.image = UIImage(named: "ic_apps_tab")?.withRenderingMode(.alwaysOriginal)
        controllers[1].tabBarItem.selectedImage = UIImage(named: "ic_apps_tab_sl")?.withRenderingMode(.alwaysOriginal)
        controllers[2].tabBarItem.image = UIImage(named: "ic_setting_tab")?.withRenderingMode(.alwaysOriginal)
        controllers[2].tabBarItem.selectedImage = UIImage(named: "ic_setting_tab_sl")?.withRenderingMode(.alwaysOriginal)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "181818")

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
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
