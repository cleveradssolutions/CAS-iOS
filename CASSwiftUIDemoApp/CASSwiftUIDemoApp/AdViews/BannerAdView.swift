import CleverAdsSolutions
import SwiftUI

struct BannerAdView: UIViewRepresentable {
    @EnvironmentObject private var adViewState: AdViewState
    @Binding var adSize: CASSize

    var onAdLoad: (() -> Void)?
    var onAdFailed: ((CASError) -> Void)?
    var onAdRevenuePaid: ((CASImpression) -> Void)?
    var onAdClick: (() -> Void)?

    internal init(adSize: Binding<CASSize> = .constant(.banner),
                  onAdLoad: (() -> Void)? = nil,
                  onAdFailed: ((CASError) -> Void)? = nil,
                  onAdRevenuePaid: ((CASImpression) -> Void)? = nil,
                  onAdClick: (() -> Void)? = nil) {
        _adSize = adSize
        self.onAdLoad = onAdLoad
        self.onAdFailed = onAdFailed
        self.onAdRevenuePaid = onAdRevenuePaid
        self.onAdClick = onAdClick
    }

    /// Make AdCoordinator with CASBannerView
    func makeCoordinator() -> AdCoordinator {
        print("BannerAdView.makeCoordinator")
        let bannerAd = CASBannerView(adSize: adSize, manager: adViewState.manager)
        let coordinator = AdCoordinator(representable: self, bannerAd: bannerAd)
        bannerAd.adDelegate = coordinator
        bannerAd.isAutoloadEnabled = true
        return coordinator
    }

    func makeUIView(context: Context) -> CASBannerView {
        print("BannerAdView.makeUIView")
        return context.coordinator.bannerAd
    }

    /// Make any view changes here, such as Ad Size, IsHidden flag, Ad Refresh interval, and more.
    func updateUIView(_ uiView: CASBannerView, context: Context) {
        print("BannerAdView.updateUIView")
        context.coordinator.representable = self
        context.coordinator.bannerAd.adSize = adSize
    }

    @available(iOS 16.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: CASBannerView, context: Context) -> CGSize? {
        // To support iOS versions below 16.0, you must fixed view size with call:
        // BannerAdView(...)
        //    .fixedSize()
        return uiView.intrinsicContentSize
    }

    /// Cleans up the presented Banner Ad view (and coordinator) in anticipation of their removal.
    static func dismantleUIView(_ uiView: CASBannerView, coordinator: AdCoordinator) {
        print("BannerAdView.dismantleUIView")
        let bannerAd = coordinator.bannerAd
        bannerAd.adDelegate = nil
        bannerAd.destroy()
    }

    class AdCoordinator: CASBannerDelegate {
        var representable: BannerAdView
        let bannerAd: CASBannerView

        init(representable: BannerAdView, bannerAd: CASBannerView) {
            self.representable = representable
            self.bannerAd = bannerAd
        }

        func bannerAdViewDidLoad(_ view: CASBannerView) {
            representable.onAdLoad?()
        }

        func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
            representable.onAdFailed?(error)
        }

        func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
            representable.onAdRevenuePaid?(impression)
        }

        func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
            representable.onAdClick?()
        }
    }
}
