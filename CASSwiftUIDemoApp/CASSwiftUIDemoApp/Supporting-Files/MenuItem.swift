import SwiftUI

enum MenuItem: String, Identifiable, CaseIterable {
    var id: Self { self }

    case banner = "Banner"
    case adaptiveBanner = "Adaptive Banner"
    case mrecBanner = "MREC Banner"
    case interstitial = "Interstitial"
    case rewarded = "Rewarded"

    @ViewBuilder
    func makeContentView() -> some View {
        switch self {
        case .banner:
            BannerContentView()
        case .mrecBanner:
            MRECBannerContentView()
        case .adaptiveBanner:
            AdaptiveBannerContentView()
        case .interstitial:
            InterstitialAdContentView()
        case .rewarded:
            RewardedAdContentView()
        }
    }
}
