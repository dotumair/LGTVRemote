
import UIKit

enum ButtonsType: String, CaseIterable {
    case main
    case circular
    case others
}

extension ButtonsType {
    var limit: Int {
        return CLConfigService.shared.getButtonLimit(for: self)
    }
}

class AppButtonsClickManager {
    static let shared = AppButtonsClickManager()
    
    private let counterKeyPrefix = "button_click_count_"
    private let defaults = UserDefaults.standard

    // Limit for button clicks
//    private let clickLimit = 25

    func handleClick(for type: ButtonsType, normalAction: () -> Void, limitAction: () -> Void) {
        let key = counterKeyPrefix + type.rawValue
        var count = defaults.integer(forKey: key)
        
        if (count >= type.limit) && !InAppService.shared.isProUser {
            // Already over limit → call alternate action
            limitAction()
        } else {
            // Allow normal action
            normalAction()
            count += 1
            defaults.set(count, forKey: key)
        }
    }
}
