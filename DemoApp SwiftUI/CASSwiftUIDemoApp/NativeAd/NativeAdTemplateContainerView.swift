import CleverAdsSolutions
import SwiftUI

struct NativeAdTemplateContainerView: View {
    var body: some View {
        VStack() {
            GeometryReader { geometry in
                let templateSize = AdSize.getInlineBanner(width: geometry.size.width,
                                                          maxHeight: geometry.size.height)
                Spacer()
                NativeAdTemplateView(adSize: templateSize)
            }
        }
    }
}
