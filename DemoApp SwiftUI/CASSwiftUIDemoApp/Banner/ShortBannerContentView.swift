//

import SwiftUI

struct MRECBannerContentView: View {
    var body: some View {
        // You can use the following line when you don't want to change Ad Size and don't want to follow the lifecycle of ads.
        BannerAdView(adSize: .constant(.mediumRectangle))
            .fixedSize() // Fixes this view at its ideal size.
    }
}

struct MRECBannerContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
