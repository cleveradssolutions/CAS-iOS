import CleverAdsSolutions
import SwiftUI

struct AdaptiveBannerContainerView: View {
    var body: some View {
        GeometryReader { geometry in
            let adaptiveSize = AdSize.getAdaptiveBanner(forMaxWidth: geometry.size.width)

            VStack {
                BannerAdView(adSize: adaptiveSize)
                    .frame(height: adaptiveSize.height)
            }
        }
    }
}
