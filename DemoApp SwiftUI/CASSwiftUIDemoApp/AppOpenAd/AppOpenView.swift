import SwiftUI

struct AppOpenView: View {
    @StateObject var appOpenAdModel = AppOpenAdModel()

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                AdButton("Present", action: {
                    appOpenAdModel.presentAd()
                })

                AdButton("Load", action: {
                    appOpenAdModel.loadAd()
                })
            }
            .padding(16)
            Spacer()
        }
    }
}
