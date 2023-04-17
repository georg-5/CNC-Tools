import SwiftUI
import GoogleMobileAds

struct BannerView: View {
    @StateObject private var adBanner = AdBanner()

    var body: some View {
        HStack {
            VStack {
                Spacer()
                AdBannerRepresentable(adBanner: adBanner)
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
        }
    }
}

struct AdBannerRepresentable: UIViewRepresentable {
    let adBanner: AdBanner

    func makeUIView(context: Context) -> GADBannerView {
        adBanner.bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) { }
}

