//

import CleverAdsSolutions
import SwiftUI

struct InterstitialAdContentView: View {
    @EnvironmentObject private var adViewState: AdViewState
    @StateObject var callbacksModel = AdCallbacksViewModel()
    @State var isAdPresented = false

    var body: some View {
        List {
            Section {
                Button("Present Ad") {
                    isAdPresented.toggle()
                }
                .disabled(isAdPresented || !adViewState.isReadyInterstitial)
            }
            AdCallbacksView(model: callbacksModel)
        }
        .interstitialAd(
            isPresented: $isAdPresented,
            onAdPresent: callbacksModel.didAdPresented(_:),
            onAdPresentFail: callbacksModel.didAdFailed(_:),
            onAdRevenuePaid: callbacksModel.didAdRevenuePaid(_:),
            onAdClick: callbacksModel.didAdClicked,
            onAdDismiss: callbacksModel.didAdDismissed)
        .onChange(of: adViewState.isReadyInterstitial) { isReady in
            if isReady {
                callbacksModel.didAdLoaded()
            } else {
                callbacksModel.didAdFailed(.noFill)
            }
        }
    }
}

struct InterstitialAdContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
