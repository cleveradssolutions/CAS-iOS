import CleverAdsSolutions
import SwiftUI

struct BannerContainerView: View {
    
    var body: some View {
        VStack() {
            BannerAdView(adSize: AdSize.banner)
                .fixedSize()
                .frame(maxWidth: .infinity) // to center horizontally
        }
    }
}
