import Foundation
import SwiftUI

enum AdContainer: CaseIterable, Hashable {
    case banner
    case adaptiveBanner
    case mrecBanner
    case appOpen
    case interstitial
    case rewarded
    case native
    case nativeTemplate

    var title: String {
        switch self {
        case .banner:
            return "Banner Ad"
        case .adaptiveBanner:
            return "Adaptive Banner Ad"
        case .mrecBanner:
            return "Medium Rectangle Ad"
        case .native:
            return "Native Ad"
        case .nativeTemplate:
            return "Native Ad Template"
        case .appOpen:
            return "AppOpen Ad"
        case .interstitial:
            return "Interstitial Ad"
        case .rewarded:
            return "Rewarded Ad"
        }
    }
    
    @ViewBuilder
    var container: some View {
        switch self {
        case .banner:
            BannerContainerView()
        case .adaptiveBanner:
            AdaptiveBannerContainerView()
        case .mrecBanner:
            MediumRectangleContainerView()
        case .native:
            NativeAdContainerView()
        case .nativeTemplate:
            NativeAdTemplateContainerView()
        case .appOpen:
            AppOpenView()
        case .interstitial:
            InterstitialView()
        case .rewarded:
            RewardedView()
        }
    }
}
