import Foundation
import StoreKit

class StoreKitManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var premiumUnlocked: Bool = UserDefaults.standard.bool(forKey: "premiumUnlocked")
    var productRequest: SKProductsRequest!
    @Published var product: SKProduct?
    
    func getProducts() {
        let productIdentifiers = Set(["RemoveAD_and_ADDFUNCS"])
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            self.product = product
        }
    }
    
    func purchaseProduct() {
        if let product = product {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                premiumUnlocked = true
                UserDefaults.standard.set(true, forKey: "premiumUnlocked")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
