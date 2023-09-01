import CleverAdsSolutions
import SwiftUI

struct FullscreenAdRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject private var adViewState: AdViewState

    @Binding var isPresented: Bool
    let isRewardedAd: Bool

    var onAdPresent: ((CASImpression) -> Void)? = nil
    var onAdPresentFail: ((CASError) -> Void)? = nil
    var onAdRevenuePaid: ((CASImpression) -> Void)? = nil
    var onUserEarnReward: (() -> Void)? = nil
    var onAdClick: (() -> Void)? = nil
    var onAdDismiss: (() -> Void)? = nil

    func makeCoordinator() -> AdCoordinator {
        print("FullscreenAdRepresentable.makeCoordinator")
        return AdCoordinator(representable: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        print("FullscreenAdRepresentable.makeUIViewController")
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("FullscreenAdRepresentable.updateUIViewController")

        context.coordinator.representable = self

        if isPresented && !context.coordinator.willPresent {
            context.coordinator.willPresent = true
            if isRewardedAd {
                adViewState.manager.presentRewardedAd(
                    fromRootViewController: uiViewController,
                    callback: context.coordinator
                )
            } else {
                adViewState.manager.presentInterstitial(
                    fromRootViewController: uiViewController,
                    callback: context.coordinator
                )
            }
        }
    }

    class AdCoordinator: CASPaidCallback {
        var representable: FullscreenAdRepresentable
        var willPresent = false

        internal init(representable: FullscreenAdRepresentable) {
            self.representable = representable
        }

        func willShown(ad adStatus: CASImpression) {
            if representable.isRewardedAd {
                representable.adViewState.isReadyRewarded = false
            } else {
                representable.adViewState.isReadyInterstitial = false
            }
            representable.onAdPresent?(adStatus)
        }

        func didPayRevenue(for ad: CASImpression) {
            representable.onAdRevenuePaid?(ad)
        }

        func didShowAdFailed(error: String) {
            if let closure = representable.onAdPresentFail {
                closure(CASError.fromMessage(error))
            }
            // CAS does not call didClosedAd() after the show fails.
            // Call it manually to correctly dismiss the ad.
            didClosedAd()
        }

        func didClickedAd() {
            representable.onAdClick?()
        }

        func didCompletedAd() {
            representable.onUserEarnReward?()
        }

        func didClosedAd() {
            willPresent = false
            representable.isPresented = false
            representable.onAdDismiss?()
        }
    }
}
