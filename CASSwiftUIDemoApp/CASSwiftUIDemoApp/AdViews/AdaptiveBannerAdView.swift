import CleverAdsSolutions
import SwiftUI

struct AdaptiveBannerAdView: UIViewControllerRepresentable {
    @EnvironmentObject private var adViewState: AdViewState
    @State private var adSize: CASSize?

    var onAdLoad: (() -> Void)?
    var onAdFail: ((CASError) -> Void)?
    var onAdRevenuePaid: ((CASImpression) -> Void)?
    var onAdClick: (() -> Void)?

    /// Make AdCoordinator with CASBannerView
    func makeCoordinator() -> AdCoordinator {
        print("AdaptiveBannerAdView.makeCoordinator")
        return AdCoordinator(representable: self)
    }

    /// Make AdViewController with Banner Ad View
    func makeUIViewController(context: Context) -> AdViewController {
        print("AdaptiveBannerAdView.makeUIViewController")
        let bannerAd = CASBannerView(adSize: .banner, manager: adViewState.manager)
        let controller = AdViewController(bannerAd: bannerAd)

        bannerAd.isAutoloadEnabled = false
        bannerAd.rootViewController = controller

        controller.adSizeBinding = $adSize
        controller.view.addSubview(bannerAd)
        return controller
    }

    /// Make any view changes here, such as Ad Size
    func updateUIViewController(_ uiViewController: AdViewController, context: Context) {
        print("AdaptiveBannerAdView.updateUIViewController")
        context.coordinator.representable = self
        if let adSize = adSize {
            let bannerAd = uiViewController.bannerAd
            bannerAd.isAutoloadEnabled = true
            bannerAd.adDelegate = context.coordinator
            bannerAd.adSize = adSize
        }
    }

    /// Cleans up the presented Banner Ad view (and coordinator) in anticipation of their removal.
    static func dismantleUIViewController(_ uiViewController: AdViewController, coordinator: AdCoordinator) {
        print("AdaptiveBannerAdView.updateUIViewController")
        uiViewController.adSizeBinding = nil
        uiViewController.bannerAd.adDelegate = nil
        uiViewController.bannerAd.destroy()
    }

    class AdCoordinator: CASBannerDelegate {
        var representable: AdaptiveBannerAdView

        init(representable: AdaptiveBannerAdView) {
            self.representable = representable
        }

        func bannerAdViewDidLoad(_ view: CASBannerView) {
            representable.onAdLoad?()
        }

        func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
            representable.onAdFail?(error)
        }

        func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
            representable.onAdRevenuePaid?(impression)
        }

        func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
            representable.onAdClick?()
        }
    }

    class AdViewController: UIViewController {
        var bannerAd: CASBannerView
        var adSizeBinding: Binding<CASSize?>?

        init(bannerAd: CASBannerView) {
            self.bannerAd = bannerAd
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidAppear(_ animated: Bool) {
            print("viewDidAppear")
            super.viewDidAppear(animated)
            adaptAdSizeToWidth()
        }

        override func viewWillTransition(to size: CGSize,
                                         with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animate { _ in
                // Wait for the animation to complete change orientation
            } completion: { _ in
                self.adaptAdSizeToWidth()
            }
        }

        func adaptAdSizeToWidth() {
            print("Adaptive size changed")
            guard let binding = adSizeBinding else { return }
            let maxWidth = view.frame.inset(by: view.safeAreaInsets).size.width
            if maxWidth == 0.0 {
                print("To use adaptive banner, you should allow the view to expand horizontal size.")
            }
            let newSize = CASSize.getAdaptiveBanner(forMaxWidth: maxWidth)

            print("Adaptive size changed to \(newSize)")
            // Set ideal content height for current max width
            preferredContentSize = CGSize(width: view.frame.size.width, height: newSize.height)
            binding.wrappedValue = newSize
        }
    }
}
