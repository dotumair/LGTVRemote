
import Foundation
import UIKit

extension UserDefaults {
    var vibrationEnabled: Bool {
        get {
            return value(forKey: #function) as? Bool ?? true
        }
        set {setValue(newValue, forKey: #function)}
    }
}
