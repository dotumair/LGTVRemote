
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}

enum Storyboards: String {
    case Main = "Main"
}

extension UIViewController {
    static func initController(from: Storyboards) -> UIViewController {
        return UIStoryboard(name: from.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: "\(self)")
    }
    
    func showAlert(title: String = "Message", message: String?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .default))
        present(vc, animated: true)
    }
    
    func presentInAppScreen() {
        guard InAppService.shared.productsLoaded else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else {return}
                self.presentInAppScreen()
            }
            return
        }
        
        if InAppService.shared.isProUser { return }

        if true {
            let vc = PurchaseScreen()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let vc = TrialPurchaseScreen()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

extension UINavigationController {
    func removeControllerFromStack(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
