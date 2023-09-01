import CleverAdsSolutions
import SwiftUI

class AdViewState: ObservableObject, CASLoadDelegate {
    @Published var isReadyInterstitial: Bool
    @Published var isReadyRewarded: Bool

    var manager: CASMediationManager

    init(manager: CASMediationManager) {
        self.manager = manager
        _isReadyInterstitial = .init(initialValue: manager.isInterstitialReady)
        _isReadyRewarded = .init(initialValue: manager.isRewardedAdReady)

        manager.adLoadDelegate = self
        print("AdViewState.init")
    }

    func onAdLoaded(_ adType: CASType) {
        DispatchQueue.main.async {
            if adType == .interstitial {
                print("AdViewState.onAdLoaded Interstitial")
                self.isReadyInterstitial = true
            } else if adType == .rewarded {
                print("AdViewState.onAdLoaded Rewarded")
                self.isReadyRewarded = true
            }
        }
    }

    func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        DispatchQueue.main.async {
            if adType == .interstitial {
                print("AdViewState.onAdFailedToLoad Interstitial: \(error ?? "")")
                self.isReadyInterstitial = false
            } else if adType == .rewarded {
                print("AdViewState.onAdFailedToLoad Rewarded: \(error ?? "")")
                self.isReadyRewarded = false
            }
        }
    }
}
