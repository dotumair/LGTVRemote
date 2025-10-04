
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.gotoMain()
        })
    }
    
    private func gotoMain() {
        #if DEBUG
//        UserDefaults.standard.removeObject(forKey: "firstLaunch")
        #endif
        let firstLaunch = UserDefaults.standard.value(forKey: "firstLaunch") as? Int ?? 0
        if firstLaunch == 0 {
            UserDefaults.standard.set(1, forKey: "firstLaunch")
            UserDefaults.standard.synchronize()
            
            let vc = OnboardingController()
            self.navigationController?.setViewControllers([vc], animated: true)
        } else {
            let vc = MainTabBarVC.initController(from: Storyboards.Main)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
