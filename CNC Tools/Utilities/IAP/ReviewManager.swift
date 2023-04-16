import SwiftUI
import StoreKit

class ReviewManager: ObservableObject {
    private let appLaunchCountKey = "appLaunchCount"
    private let nextRequestReviewCountKey = "nextRequestReviewCount"
    private let minimumLaunchesBeforeReview = 3
    private let additionalLaunchesBeforeReview = 5

    init() {
        incrementLaunchCount()
    }

    private func incrementLaunchCount() {
        let currentCount = UserDefaults.standard.integer(forKey: appLaunchCountKey)
        UserDefaults.standard.set(currentCount + 1, forKey: appLaunchCountKey)
    }

    private func shouldRequestReview() -> Bool {
        let currentCount = UserDefaults.standard.integer(forKey: appLaunchCountKey)
        let nextRequestReviewCount = UserDefaults.standard.integer(forKey: nextRequestReviewCountKey)

        if currentCount >= nextRequestReviewCount {
            UserDefaults.standard.set(currentCount + additionalLaunchesBeforeReview, forKey: nextRequestReviewCountKey)
            return true
        }

        return false
    }

    func requestReview() {
        if shouldRequestReview(),
           let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    func showReviewAlertAfterDelay() {
        if UserDefaults.standard.integer(forKey: nextRequestReviewCountKey) == 0 {
            UserDefaults.standard.set(minimumLaunchesBeforeReview, forKey: nextRequestReviewCountKey)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 800) {
            self.requestReview()
        }
    }
}
