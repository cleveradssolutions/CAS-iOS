import SwiftUI

struct AppOpenView: View {
    @StateObject var appOpenAdModel = AppOpenAdModel()

    var body: some View {
        VStack(spacing: 10) {
            AdButton("Load", action: {
                appOpenAdModel.loadAd()
            })
            AdButton("Present", action: {
                appOpenAdModel.presentAd()
            })
        }
    }
}
