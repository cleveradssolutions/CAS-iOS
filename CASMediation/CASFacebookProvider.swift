//
//  FacebookProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(FBAudienceNetwork)
    import CleverAdsSolutions
    import FBAudienceNetwork
    import Foundation

    final class CASFacebookProvider: NSObject, CASProvider {
        private weak var delegate: CASMediationWrapper?
        private var allPlacements = Set<String>()

        func getVersionAndVerify() throws -> String {
            if NSClassFromString("FBAudienceNetworkAds") == nil {
                throw CASError.notImplemented
            }
            return FB_AD_SDK_VERSION
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)

            let param: [String: Any]
            if info.isDemo {
                param = ["banner_PlacementID": "YOUR_PLACEMENT_ID",
                         "inter_PlacementID": "YOUR_PLACEMENT_ID",
                         "reward_PlacementID": "YOUR_PLACEMENT_ID"]
            } else {
                param = try info.readSettings()
            }
            if let bannerId = param["banner_PlacementID"] as? String {
                allPlacements.insert(bannerId)
            }
            if let interId = param["inter_PlacementID"] as? String {
                allPlacements.insert(interId)
            }
            if let rewardID = param["reward_PlacementID"] as? String {
                allPlacements.insert(rewardID)
            }
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            if allPlacements.isEmpty {
                wrapper.onInitialized(success: false, "Have no placements")
            }

            wrapper.settings.appendOptionChanged(delegate: self)
            onChangedState(ccpa: wrapper.settings.getCCPAStatus())
            let audience = wrapper.settings.getTaggedAudience()
            if audience == .children {
                onChangedTagged(audience: audience)
            }

            if wrapper.settings.isDebugMode() {
                FBAdSettings.loggingDelegate = self
                wrapper.log("Test device hash: \(FBAdSettings.testDeviceHash())")
            }

            if !wrapper.settings.getTestDeviceIDs().isEmpty {
                FBAdSettings.addTestDevices(wrapper.settings.getTestDeviceIDs())
            }

            let settings = FBAdInitSettings(placementIDs: Array(allPlacements),
                                            mediationService: "CAS:\(CAS.getSDKVersion())")

            FBAudienceNetworkAds.initialize(with: settings) { result in
                wrapper.onInitialized(success: result.isSuccess, result.message)
            }
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(placement:
                try info.readString(forKey: "banner_PlacementID", "YOUR_PLACEMENT_ID", nil))
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(placement:
                try info.readString(forKey: "inter_PlacementID", "YOUR_PLACEMENT_ID", nil))
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return RewardedAgent(placement:
                try info.readString(forKey: "reward_PlacementID", "YOUR_PLACEMENT_ID", nil))
        }
    }

    extension CASFacebookProvider: CASOptionsListener, FBAdLoggingDelegate {
        func log(at level: FBAdLogLevel, withFileName fileName: String,
                 withLineNumber lineNumber: Int32, withThreadId threadId: Int, withBody body: String) {
            delegate?.log(body)
        }

        func onChangedState(gdpr: CASConsentStatus) {
        }

        func onChangedState(ccpa: CASCCPAStatus) {
            if ccpa == .optOutSale {
                FBAdSettings.setDataProcessingOptions(["LDU"], country: 1, state: 1000)
            } else {
                FBAdSettings.setDataProcessingOptions([])
            }
        }

        func onChangedTagged(audience: CASAudience) {
            FBAdSettings.isMixedAudience = audience == .children
        }

        func onChangedDebugMode(_ debug: Bool) {
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
        }
    }

    private class BannerAgent: CASBannerAgent {
        private let placement: String
        private var view: FBAdView?

        init(placement: String) {
            self.placement = placement
            super.init(true, 3)
        }

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String {
            return FB_AD_SDK_VERSION
        }

        override func requestAd() throws {
            if loadedSize != size || loadedSizeIndex < 0 {
                let targetWidth = size.width
                let validSize = findClosestSize([
                    CGSize(width: targetWidth, height: 50),
                    CGSize(width: targetWidth, height: 90),
                    CGSize(width: targetWidth, height: 250)]
                )

                if validSize < 0 {
                    return
                }
            }

            if isAdReady() {
                onAdLoaded()
                return
            }

            CASHandler.main {
                if let view = self.view {
                    view.loadAd()
                } else {
                    self.createBanner()
                }
            }
            try super.requestAd()
        }

        private func createBanner() {
            let fbSize: FBAdSize
            switch loadedSizeIndex {
            case 0: fbSize = kFBAdSizeHeight50Banner
            case 1: fbSize = kFBAdSizeHeight90Banner
            case 2: fbSize = kFBAdSizeHeight250Rectangle
            default:
                onAdWrongSize()
                return
            }
            let newView = FBAdView(placementID: placement, adSize: fbSize, rootViewController: rootViewController)
            newView.delegate = self
            view = newView
            newView.loadAd()
        }

        override func isAdReady() -> Bool {
            return view?.isAdValid == true
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension BannerAgent: FBAdViewDelegate {
        func adViewDidLoad(_ adView: FBAdView) {
            onAdLoaded()
        }

        func adView(_ adView: FBAdView, didFailWithError error: Error) {
            // Error Codes = https://developers.facebook.com/docs/audience-network/guides/test/checklist-errors/
            let ns = (error as NSError)
            onAdFailedToLoad("\(ns.localizedDescription) Code: \(ns.code)")
        }

        func adViewDidClick(_ adView: FBAdView) {
            onAdClicked()
        }

        var viewControllerForPresentingModalView: UIViewController {
            return rootViewController!
        }
    }

    private class InterstitialAgent: CASAgent {
        private let placement: String
        private var view: FBInterstitialAd?

        init(placement: String) {
            self.placement = placement
            super.init()
        }

        override var versionInfo: String {
            return FB_AD_SDK_VERSION
        }

        override func requestAd() throws {
            CASHandler.main {
                let newView = FBInterstitialAd(placementID: self.placement)
                newView.delegate = self
                self.view = newView
                newView.load()
            }
        }

        override func isAdReady() -> Bool {
            return view?.isAdValid == true
        }

        override func isAdCached() -> Bool {
            return view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = view else {
                throw CASError.nilOptional("View")
            }
            if view.show(fromRootViewController: controller) {
                onAdShown()
            } else {
                self.view = nil
                throw CASError.cause("Show failed")
            }
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension InterstitialAgent: FBInterstitialAdDelegate {
        func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
            onAdLoaded()
        }

        func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
            let ns = (error as NSError)
            if isVisible {
                showFailed("\(ns.localizedDescription) Code: \(ns.code)")
            } else {
                onAdFailedToLoad("\(ns.localizedDescription) Code: \(ns.code)")
            }
        }

        func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {
            onAdClicked()
        }

        func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
            view = nil
            onAdWillClose()
        }

        func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
            onAdClosed()
        }
    }

    private class RewardedAgent: CASAgent {
        private let placement: String
        private var view: FBRewardedVideoAd?

        init(placement: String) {
            self.placement = placement
            super.init()
        }

        override var versionInfo: String {
            return FB_AD_SDK_VERSION
        }

        override func requestAd() throws {
            CASHandler.main {
                let newView = FBRewardedVideoAd(placementID: self.placement)
                newView.delegate = self
                self.view = newView
                newView.load()
            }
        }

        override func isAdReady() -> Bool {
            return view?.isAdValid == true
        }

        override func isAdCached() -> Bool {
            return view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = view else {
                throw CASError.nilOptional("View")
            }
            if view.show(fromRootViewController: controller, animated: true) {
                onAdShown()
            } else {
                self.view = nil
                throw CASError.cause("Show failed")
            }
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension RewardedAgent: FBRewardedVideoAdDelegate {
        func rewardedVideoAdDidLoad(_ rewardedVideoAd: FBRewardedVideoAd) {
            onAdLoaded()
        }

        func rewardedVideoAd(_ rewardedVideoAd: FBRewardedVideoAd, didFailWithError error: Error) {
            let ns = (error as NSError)
            if isVisible {
                showFailed("\(ns.localizedDescription) Code: \(ns.code)")
            } else {
                onAdFailedToLoad("\(ns.localizedDescription) Code: \(ns.code)")
            }
        }

        func rewardedVideoAdDidClick(_ rewardedVideoAd: FBRewardedVideoAd) {
            onAdClicked()
        }

        func rewardedVideoAdWillClose(_ rewardedVideoAd: FBRewardedVideoAd) {
            onAdWillClose()
        }

        func rewardedVideoAdDidClose(_ rewardedVideoAd: FBRewardedVideoAd) {
            view = nil
            onAdClosed()
        }

        func rewardedVideoAdVideoComplete(_ rewardedVideoAd: FBRewardedVideoAd) {
            onAdCompleted()
        }
    }
#endif
