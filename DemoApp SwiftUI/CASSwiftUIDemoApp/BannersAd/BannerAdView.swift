import CleverAdsSolutions
import SwiftUI

struct BannerAdView: UIViewRepresentable {
    var adSize: CASSize

    func makeCoordinator() -> Coordinator {
        print(#function)
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> CASBannerView {
        print(#function)
        return context.coordinator.bannerView
    }

    func updateUIView(_ uiView: CASBannerView, context: Context) {
        print(#function)
        uiView.adSize = adSize
    }

    static func dismantleUIView(_ uiView: CASBannerView, coordinator: Coordinator) {
        print(#function)
        uiView.delegate = nil
        uiView.impressionDelegate = nil
        uiView.destroy()
    }

    class Coordinator: NSObject, CASBannerDelegate, CASImpressionDelegate {
        let parent: BannerAdView
        let bannerView: CASBannerView

        init(parent: BannerAdView) {
            self.parent = parent
            bannerView = CASBannerView(casID: CASSwiftUIDemoAppApp.casID,
                                       size: parent.adSize)
            super.init()
            bannerView.delegate = self
            bannerView.impressionDelegate = self
            bannerView.isAutoloadEnabled = true
        }

        // MARK: - CASBannerDelegate

        func bannerAdViewDidLoad(_ view: CASBannerView) {
            print(#function)
        }

        func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
            print(#function, "Error: \(error.description)")
        }

        func bannerAdView(_ adView: CASBannerView, willPresent impression: any CASImpression) {
            print(#function)
        }

        func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
            print(#function)
        }

        // MARK: - CASImpressionDelegate

        func adDidRecordImpression(info: AdContentInfo) {
            print(#function)
        }
    }
}
