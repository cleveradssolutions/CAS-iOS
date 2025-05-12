import SwiftUI

struct InterstitialView: View {
    @StateObject var interstitialAdModel = InterstitialAdModel()

    var body: some View {
        VStack(spacing: 10) {
            AdButton("Load", action: {
                interstitialAdModel.loadAd()
            })
            AdButton("Present", action: {
                interstitialAdModel.presentAd()
            })
        }
    }
}
