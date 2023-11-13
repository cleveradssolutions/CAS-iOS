
import CleverAdsSolutions
import SwiftUI

class AdCallbacksViewModel: ObservableObject {
    @Published var list: [AdCallbacksView.Item] = []

    func didCallback(_ name: String) {
        withAnimation {
            list.append(.init(name: name))
        }
    }

    func didAdLoaded() {
        print("Callback Ad Loaded")
        didCallback("Ad Loaded")
    }

    func didAdFailed(_ error: CASError) {
        print("Callback Ad Failed: \(error.localizedDescription)")
        didCallback("Ad Failed: \(error.localizedDescription)")
    }

    func didAdClicked() {
        print("Callback Ad Clicked")
        didCallback("Ad Clicked")
    }

    func didAdPresented(_ ad: CASImpression) {
        print("Callback Ad Presented")
        didCallback("Ad Presented")
    }

    func didAdRevenuePaid(_ ad: CASImpression) {
        print("Callback Ad Revenue paid: \(ad.cpm / 1000.0)")
        didCallback("Ad Revenue paid: \(ad.cpm / 1000.0)")
    }

    func didUserEarnReward() {
        print("Callback Ad User Earn Reward")
        didCallback("User Earn Reward")
    }

    func didAdDismissed() {
        print("Callback Ad Dismissed")
        didCallback("Ad Dismissed")
    }
}
