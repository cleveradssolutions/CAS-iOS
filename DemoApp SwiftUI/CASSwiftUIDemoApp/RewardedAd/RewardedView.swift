import SwiftUI

struct RewardedView: View {
    @StateObject var rewardedAdModel = RewardedAdModel()

    var body: some View {
        VStack(spacing: 10) {
            AdButton("Load", action: {
                rewardedAdModel.loadAd()
            })
            AdButton("Present", action: {
                rewardedAdModel.presentAd { _ in
                    print("Reward earned")
                }
            })
        }
    }
}
