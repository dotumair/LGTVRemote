
import UIKit
import SwiftUI

extension UIFont.Weight {
    var localName: String {
        switch self {
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        default: return "Regular" // fallback or unknown custom weights
        }
    }
}

extension UIFont {
    static func appFont(ofSize: CGFloat, weight: Weight = .regular) -> UIFont {
        guard let font = UIFont(name: "Lexend-\(weight.localName)", size: ofSize) else {
            // Fallback if custom font fails
            print("⚠️ Custom font '\(weight.rawValue)' failed to load. Using system font.")
            return UIFont.systemFont(ofSize: ofSize, weight: weight)
        }
        return font
    }
}

extension Font.Weight {
    var localName: String {
        switch self {
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        default: return "Regular" // fallback or unknown custom weights
        }
    }
}

extension Font {
    static func appFont(ofSize: CGFloat, weight: Weight = .regular) -> Font {
        return Font.custom("Lexend-\(weight.localName)", size: ofSize)
    }
}
