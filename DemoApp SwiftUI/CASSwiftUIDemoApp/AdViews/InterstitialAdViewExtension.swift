import CleverAdsSolutions
import SwiftUI

extension View {
    /// Presents a Interstitial Ads when a binding to a Boolean value that you
    /// provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the Interstitial Ad
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    public func interstitialAd(isPresented: Binding<Bool>,
                               onAdPresent: ((CASImpression) -> Void)? = nil,
                               onAdPresentFail: ((CASError) -> Void)? = nil,
                               onAdRevenuePaid: ((CASImpression) -> Void)? = nil,
                               onAdClick: (() -> Void)? = nil,
                               onAdDismiss: (() -> Void)? = nil) -> some View {
        background(
            FullscreenAdRepresentable(
                isPresented: isPresented,
                isRewardedAd: false,
                onAdPresent: onAdPresent,
                onAdPresentFail: onAdPresentFail,
                onAdRevenuePaid: onAdRevenuePaid,
                onAdClick: onAdClick,
                onAdDismiss: onAdDismiss
            )
            .frame(width: .zero, height: .zero)
        )
    }
}
