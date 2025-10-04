
import Foundation
import StoreKit

enum InAppState {
    static let loaded = NSNotification.Name("InAppState.Loaded")
    static let success = NSNotification.Name("InAppState.Success")
    static let failed = NSNotification.Name("InAppState.Failed")
}

enum InAppItem: String, CaseIterable {
    case weekly = "com.weekly"
    case monthly = "com.monthly"
    case yearly = "com.yearly"
    case lifetime = "com.lifetime"
    
    static var asList: [String] {
        return InAppItem.allCases.map { $0.rawValue }
    }
    
    static var trialPurchases: [InAppItem] {
        return [.weekly, .yearly]
    }
    
    func fetchPrice() -> String {
        guard let product = InAppService.shared.getProduct(with: self) else { return "" }
        return product.displayPrice
    }
    
    var offerText: String {
        switch self {
        case .weekly:
            return ""
        case .monthly:
            return "Save 50%"
        case .yearly:
            return "Best value"
        case .lifetime:
            return "One-time Purchase"
        }
    }
    
    var title: String {
        switch self {
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .lifetime:
            return "Lifetime"
        }
    }
    
    var duration: String {
        switch self {
        case .weekly: return "Week"
        case .monthly: return "Month"
        case .yearly: return "Year"
        case .lifetime: return "Lifetime"
        }
    }
}

// MARK: - Purchase Error
enum InAppError: Error, LocalizedError {
    case notSubscribed
    case SubscriptionFailed
    case restoreFailed
    case userCanceled
    
    var errorDescription: String? {
        switch self {
        case .notSubscribed:
            return "No active subscriptions found."
        case .SubscriptionFailed:
            return "Unable to purchase the selected product. Please try again."
        case .restoreFailed:
            return "No purchases to restore."
        case .userCanceled:
            return "Purchase Cancelled"
        }
    }
}

// MARK: - Premium Service
class InAppService {
    static let shared = InAppService()
    
    private var subscriptionList: [InAppItem: Product] = [:]
    private let proIdentifier = "TVRemoteProIdentifier"
    
    var productsLoaded: Bool {
        guard subscriptionList.count == InAppItem.allCases.count else {
            load()
            return false
        }
        return true
    }

    var isProUser: Bool {
        #if DEBUG
        return false
        #endif
        return UserDefaults.standard.bool(forKey: proIdentifier)
    }
    
    private var transactionListener: Task<Void, Never>? = nil
    
    init() {
        transactionListener = backgroundUpdates()
        verify()
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    private func backgroundUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                self.verify()
            }
        }
    }
    
    func load() {
        Task {
            let products = try await Product.products(for: InAppItem.asList)
            for product in products {
                if let identifier = InAppItem(rawValue: product.id) {
                    self.subscriptionList[identifier] = product
                }
            }
            publish(name: InAppState.loaded)
        }
    }
    
    func getProduct(with id: InAppItem) -> Product? {
        return subscriptionList[id]
    }
    
    func getTrialDays(for id: InAppItem) -> String {
        guard let product = self.subscriptionList[id] else { return "" }
        if let period = product.subscription?.introductoryOffer?.period {
            let freeDays = period.unit.formatToString(capitalizeFirstLetter: true, numberOfUnits: period.value)
            return "Try \(freeDays) Free then \(product.displayPrice)/\(id.duration)"
        } else {
            return ""
        }
    }
    
    func mockPurchase() {
        UserDefaults.standard.setValue(true, forKey: proIdentifier)
        publish(name: InAppState.success)
    }
    
    func buy(id: InAppItem, completion: @escaping (Result<Void, InAppError>) -> Void) {
        guard let product = subscriptionList[id] else {
            completion(.failure(.SubscriptionFailed))
            return
        }
        
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        UserDefaults.standard.setValue(true, forKey: proIdentifier)
                        publish(name: InAppState.success)
//                        EventReporter.shared.reportLogInAppPurchase(product: product.displayName)
                        completion(.success(()))
                    case .unverified:
                        publish(name: InAppState.failed)
                        completion(.failure(.SubscriptionFailed))
                    }
                case .pending:
                    publish(name: InAppState.failed)
                    completion(.failure(.SubscriptionFailed))
                case .userCancelled:
                    publish(name: InAppState.failed)
                    completion(.failure(.userCanceled))
                @unknown default:
                    fatalError("Unknown purchase result")
                }
            } catch {
                publish(name: InAppState.failed)
                completion(.failure(.SubscriptionFailed))
            }
        }
    }
    
    func verify() {
        UserDefaults.standard.set(false, forKey: proIdentifier)
        Task {
            var anyPurchaseDone = false
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if InAppItem.asList.contains(transaction.productID) {
                        anyPurchaseDone = true
                    }
                }
            }
            
            UserDefaults.standard.setValue(anyPurchaseDone, forKey: proIdentifier)
            publish(name: anyPurchaseDone ? InAppState.success : InAppState.failed)
        }
    }
    
    func restore(completion: @escaping (Result<Void, InAppError>) -> Void) {
        UserDefaults.standard.set(false, forKey: proIdentifier)
        
        Task {
            var restoreSuccessful = false
            
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if InAppItem.asList.contains(transaction.productID) {
                        restoreSuccessful = true
                    }
                    await transaction.finish()
                }
            }
            
            UserDefaults.standard.set(restoreSuccessful, forKey: proIdentifier)
            if restoreSuccessful {
                completion(.success(()))
            } else {
                completion(.failure(InAppError.restoreFailed))
            }
        }
    }
    
    private func publish(name: NSNotification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
}

extension Product.SubscriptionPeriod.Unit {
    func formatToString(capitalizeFirstLetter: Bool = false, numberOfUnits: Int? = nil) -> String {
        let period:String = {
            switch self {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            @unknown default:
                return ""
            }
        }()
        
        var numUnits = ""
        var plural = ""
        if let numberOfUnits = numberOfUnits {
            numUnits = "\(numberOfUnits) "
            plural = numberOfUnits > 1 ? "s" : ""
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)\(plural)"
    }
}
