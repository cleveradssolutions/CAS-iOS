import CleverAdsSolutions
import SwiftUI

extension View {
    public func rewardedAd(isPresented: Binding<Bool>,
                           onUserEarnReward: @escaping () -> Void,
                           onAdPresent: ((CASImpression) -> Void)? = nil,
                           onAdPresentFail: ((CASError) -> Void)? = nil,
                           onAdRevenuePaid: ((CASImpression) -> Void)? = nil,
                           onAdClick: (() -> Void)? = nil,
                           onAdDismiss: (() -> Void)? = nil) -> some View {
        background(
            FullscreenAdRepresentable(
                isPresented: isPresented,
                isRewardedAd: true,
                onAdPresent: onAdPresent,
                onAdPresentFail: onAdPresentFail,
                onAdRevenuePaid: onAdRevenuePaid,
                onUserEarnReward: onUserEarnReward,
                onAdClick: onAdClick,
                onAdDismiss: onAdDismiss
            )
            .frame(width: .zero, height: .zero)
        )
    }
}
