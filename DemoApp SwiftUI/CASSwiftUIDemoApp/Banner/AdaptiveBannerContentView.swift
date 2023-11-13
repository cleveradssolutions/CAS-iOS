import CleverAdsSolutions
import SwiftUI

struct AdaptiveBannerContentView: View {
    @ObservedObject var callbacksModel = AdCallbacksViewModel()

    var body: some View {
        VStack {
            // To use the adaptive banner,
            // you must not fix width of the view.
            AdaptiveBannerAdView(
                onAdLoad: callbacksModel.didAdLoaded,
                onAdFail: callbacksModel.didAdFailed(_:),
                onAdRevenuePaid: callbacksModel.didAdRevenuePaid(_:),
                onAdClick: callbacksModel.didAdClicked
            )
            // Fixes height of view at its ideal size.
            .fixedSize(horizontal: false, vertical: true)

            List {
                AdCallbacksView(model: callbacksModel)
            }
        }
    }
}

struct AdaptiveBannerContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
