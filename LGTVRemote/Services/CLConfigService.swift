
import Foundation
import FirebaseDatabase

class CLConfigService {
    static let shared = CLConfigService()
    
    private var buttonLimits: [ButtonsType: Int] = [:]

    func fetchConfigs() {
        Database.database().reference().child("config/ios").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            
            // Create a temporary dictionary to hold the new limits.
            var newLimits: [ButtonsType: Int] = [:]

            if let limitsDict = snapshot.childSnapshot(forPath: "buttonLimits").value as? [String: Any] {
                for buttonType in ButtonsType.allCases {
                    // Try to get the limit for the current button type from the dictionary.
                    if let limit = limitsDict[buttonType.rawValue] as? Int {
                        newLimits[buttonType] = limit
                    } else {
                        // Log a warning if a limit for a button type is missing.
                        print("Warning: Limit for \(buttonType.rawValue) not found in database.")
                    }
                }
            }
            
            // Update the main limits dictionary.
            self.buttonLimits = newLimits
        }
    }
    
    func getButtonLimit(for type: ButtonsType) -> Int {
        return buttonLimits[type] ?? 1
    }
}
