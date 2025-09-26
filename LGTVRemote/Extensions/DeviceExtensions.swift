
import UIKit

extension UIDevice {
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

var debugVariant: Bool {
#if DEBUG
    return true
#else
    return false
#endif
}
