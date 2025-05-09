import SwiftUI

struct RewardedView: View {
    @StateObject var rewardedAdModel = RewardedAdModel()

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                AdButton("Present", action: {
                    rewardedAdModel.presentAd { _ in
                        print("Reward earned")
                    }
                })

                AdButton("Load", action: {
                    rewardedAdModel.loadAd()
                })
            }
            .padding(16)
            Spacer()
        }
    }
}
