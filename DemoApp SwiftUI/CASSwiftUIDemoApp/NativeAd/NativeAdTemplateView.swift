import CleverAdsSolutions
import SwiftUI

struct NativeAdTemplateView: UIViewRepresentable {
    let adSize: CASSize

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
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
        let parent: NativeAdTemplateView
        let loader = CASNativeLoader(casID: AppDelegate.casID)
        let adView: CASNativeView
        var adContent: NativeAdContent?

        init(parent: NativeAdTemplateView) {
            self.parent = parent
            adView = CASNativeView()
            adView.setAdTemplateSize(parent.adSize)
            
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
