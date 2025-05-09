import CleverAdsSolutions
import SwiftUI

struct MediumRectangleContainerView: View {
    var body: some View {
        VStack() {
            BannerAdView(adSize: AdSize.mediumRectangle)
                .fixedSize()
                .frame(maxWidth: .infinity) // to center horizontally
        }
    }
}
