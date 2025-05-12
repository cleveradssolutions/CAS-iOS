import CleverAdsSolutions
import SwiftUI

struct NativeAdView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> CASNativeView {
        return context.coordinator.adView
    }

    func updateUIView(_ uiView: CASNativeView, context: Context) {}

    static func dismantleUIView(_ uiView: CASNativeView, coordinator: Coordinator) {
        coordinator.adContent?.destroy()
        coordinator.adContent = nil
    }

    class Coordinator: NSObject, CASNativeLoaderDelegate, CASNativeContentDelegate, CASImpressionDelegate {
        let loader = CASNativeLoader(casID: AppDelegate.casID)
        var adView: CASNativeView
        var adContent: NativeAdContent?

        override init() {
            let nib = UINib(nibName: "NativeAdView", bundle: .main)
            adView = nib.instantiate(withOwner: nil, options: nil).first as! CASNativeView

            adView.registerMediaView(tag: 100)
            adView.registerIconView(tag: 101)
            adView.registerHeadlineView(tag: 102)
            adView.registerAdLabelView(tag: 103)
            adView.registerBodyView(tag: 104)
            adView.registerCallToActionView(tag: 105)

            super.init()

            loader.delegate = self
            loader.adChoicesPlacement = .topRight // by default
            loader.isStartVideoMuted = true // by default
            loader.loadAd()
        }

        // MARK: - CASNativeLoaderDelegate

        func nativeAdDidLoadContent(_ ad: NativeAdContent) {
            print(#function)
            if let previousAd = adContent {
                previousAd.destroy()
            }

            adContent = ad
            ad.delegate = self
            ad.impressionDelegate = self
            adView.setNativeAd(ad)
        }

        func nativeAdDidFailToLoad(error: AdError) {
            print(#function, "Error: \(error.description)")
            
            // TODO: Implement custom retry logic with delay
        }

        // MARK: - CASNativeContentDelegate

        func nativeAd(_ ad: NativeAdContent, didFailToPresentWithError error: AdError) {
            print(#function, "Error: \(error.description)")
        }

        func nativeAdDidClickContent(_ ad: NativeAdContent) {
            print(#function)
        }

        // MARK: - CASImpressionDelegate

        func adDidRecordImpression(info: AdContentInfo) {
            print(#function)
        }
    }
}
