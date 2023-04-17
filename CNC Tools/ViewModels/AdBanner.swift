import SwiftUI
import GoogleMobileAds

final class AdBanner: NSObject, GADBannerViewDelegate, ObservableObject {
    @Published var adHeight: CGFloat = 0
    let bannerView: GADBannerView = GADBannerView(adSize: GADAdSizeBanner)

    override init() {
        super.init()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController

        let request = GADRequest()
        bannerView.load(request)
    }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        adHeight = 60
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        adHeight = 0
    }
}
