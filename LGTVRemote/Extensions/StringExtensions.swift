
import UIKit

extension String {
    func frame(size: CGSize, font: UIFont) -> CGRect {
        let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }
    
    func extractMacAddress() -> String? {
        let macAddressPattern = "([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})"
        
        do {
            let regex = try NSRegularExpression(pattern: macAddressPattern)
            if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                if let range = Range(match.range, in: self) {
                    return String(self[range])
                }
            }
        } catch {
            print("Invalid regular expression: \(error.localizedDescription)")
        }
        return nil
    }
    
    var isValidIPAddress: Bool {
        let regex = #"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
