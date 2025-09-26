
import UIKit

extension UIApplication {
    var globalSafeAreaInsets: UIEdgeInsets {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return .zero
        }
        return window.safeAreaInsets
    }
}
