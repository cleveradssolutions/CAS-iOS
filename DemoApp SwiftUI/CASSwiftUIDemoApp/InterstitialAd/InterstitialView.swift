import SwiftUI

struct InterstitialView: View {
    @StateObject var interstitialAdModel = InterstitialAdModel()

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                AdButton("Present", action: {
                    interstitialAdModel.presentAd()
                })

                AdButton("Load", action: {
                    interstitialAdModel.loadAd()
                })
            }
            .padding(16)
            Spacer()
        }
    }
}
