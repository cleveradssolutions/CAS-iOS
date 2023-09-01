//
//  BannerContentView.swift
import CleverAdsSolutions
import SwiftUI

struct BannerContentView: View {
    @ObservedObject var callbacksModel = AdCallbacksViewModel()
    @State var adSize: CASSize = .banner

    var body: some View {
        List {
            Section {
                // Any callbacks is optional.
                BannerAdView(
                    adSize: $adSize,
                    onAdLoad: callbacksModel.didAdLoaded,
                    onAdFailed: callbacksModel.didAdFailed(_:),
                    onAdRevenuePaid: callbacksModel.didAdRevenuePaid(_:),
                    onAdClick: callbacksModel.didAdClicked
                )
                .fixedSize() // Fixes this view at its ideal size.
                .frame(maxWidth: .infinity) // Set banner centered

                Picker("Ad Size", selection: $adSize) {
                    Text("320x50").tag(CASSize.banner)
                    Text("300x250 (MREC)").tag(CASSize.mediumRectangle)
                    Text("728x90 (LEAD)").tag(CASSize.leaderboard)
                }.pickerStyle(.wheel)
            }

            AdCallbacksView(model: callbacksModel)
        }
    }
}

struct BannerContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
