import Foundation
import StoreKit

@MainActor
class IAPManager: ObservableObject {
    /// # - Product ID
    private let productId = "RemoveAD_and_ADDFUNCS"
    private var updates: Task<Void, Never>? = nil

    init() {
        updates = observeTransactionUpdates()
    }
    deinit {
        updates?.cancel()
    }

    @Published private(set) var product: Product?
    private var productsLoaded = false
    @Published private(set) var purchasedProductIDs = Set<String>()
    /// # - If user buy product
    var hasUnlockedPremium: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    /// # - Load Products
    func loadProduct() async throws {
        let products = try await Product.products(for: [productId])
        self.product = products.first
    }
    /// # - Purchase
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    /// # - Product checking
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
