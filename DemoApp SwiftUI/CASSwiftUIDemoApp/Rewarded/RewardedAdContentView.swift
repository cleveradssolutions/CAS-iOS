//

import CleverAdsSolutions
import SwiftUI

struct RewardedAdContentView: View {
    @EnvironmentObject private var adViewState: AdViewState
    @StateObject var callbacksModel = AdCallbacksViewModel()
    @State var isAdPresented = false
    @State var isUserEarnReward = false

    var body: some View {
        List {
            Section {
                Button("Present Ad") {
                    isAdPresented.toggle()
                }
                .disabled(isAdPresented || !adViewState.isReadyRewarded)

                Button("Click to use Reward") {
                    callbacksModel.didCallback("Reward has been used")
                    isUserEarnReward.toggle()
                }
                .disabled(!isUserEarnReward)
            }

            AdCallbacksView(model: callbacksModel)
        }
        .rewardedAd(
            isPresented: $isAdPresented,
            onUserEarnReward: {
                callbacksModel.didUserEarnReward()
                isUserEarnReward = true
            },
            onAdPresent: callbacksModel.didAdPresented(_:),
            onAdPresentFail: callbacksModel.didAdFailed(_:),
            onAdRevenuePaid: callbacksModel.didAdRevenuePaid(_:),
            onAdClick: callbacksModel.didAdClicked,
            onAdDismiss: callbacksModel.didAdDismissed)
        .onChange(of: adViewState.isReadyRewarded) { isReady in
            if isReady {
                callbacksModel.didAdLoaded()
            } else {
                callbacksModel.didAdFailed(.noFill)
            }
        }
    }
}

struct RewardedAdContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
