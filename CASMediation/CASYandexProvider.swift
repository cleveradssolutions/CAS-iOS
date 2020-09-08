//
//  YandexProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(YandexMobileAds)
    import CleverAdsSolutions
    import Foundation
    import YandexMobileAds

    final class CASYandexProvider: NSObject, CASProvider {
        func getVersionAndVerify() throws -> String {
            if NSClassFromString("YMAMobileAds") == nil {
                throw CASError.notImplemented
            }
            return YMAMobileAds.sdkVersion()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            onChangedTagged(audience: wrapper.settings.getTaggedAudience())
            onChangedDebugMode(wrapper.settings.isDebugMode())
            let consent = wrapper.settings.getUserConsent()
            if consent != .undefined {
                onChangedState(gdpr: consent)
            }
            wrapper.settings.appendOptionChanged(delegate: self)
            wrapper.onInitialized(success: true, "")
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(placement:
                try info.readString(forKey: "banner_id", "R-M-DEMO-adaptive-sticky", nil))
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            let placement: String
            if info.isDemo {
                if UIDevice.current.orientation == .portrait {
                    placement = "R-M-DEMO-240x400-context"
                } else {
                    placement = "R-M-DEMO-400x240-context"
                }
            } else {
                placement = try info.readString(forKey: "inter_id", "", nil)
            }
            return InterstitialAgent(placement: placement)
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return RewardedAgent(placement:
                try info.readString(forKey: "reward_id", "R-M-DEMO-rewarded-client-side-rtb", nil))
        }
    }

    extension CASYandexProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {
            YMAMobileAds.setUserConsent(gdpr == .accepted)
        }

        func onChangedState(ccpa: CASCCPAStatus) {
        }

        func onChangedTagged(audience: CASAudience) {
            YMAMobileAds.setLocationTrackingEnabled(audience != .children)
        }

        func onChangedDebugMode(_ debug: Bool) {
            if debug {
                YMAMobileAds.enableLogging()
            }
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
        }
    }

    private class BannerAgent: CASBannerAgent {
        private let placement: String
        private var view: YMAAdView?

        init(placement: String) {
            self.placement = placement
            super.init(true, 3)
        }

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String {
            return YMAMobileAds.sdkVersion()
        }

        override func requestAd() throws {
            if isAdReady() {
                onAdLoaded()
                return
            }
            disposeAd()
            loadedSize = size // After Dispose only

            CASHandler.main {
                self.createBanner()
            }
            try super.requestAd()
        }

        private func createBanner() {
            let yanSize: YMAAdSize
            if loadedSize.isAdaptive {
                yanSize = YMAAdSize.flexibleSize(with: loadedSize.toCGSize())
            } else {
                yanSize = YMAAdSize.fixedSize(with: loadedSize.toCGSize())
            }

            let newView = YMAAdView(
                blockID: getTargetPlacement(),
                adSize: yanSize,
                delegate: self
            )
            view = newView
            newView?.loadAd()
        }

        private func getTargetPlacement() -> String {
            if !isDemo() {
                return placement
            }
            let validSize = findClosestSize([CGSize(width: 320, height: 50),
                                             CGSize(width: 728, height: 90),
                                             CGSize(width: 300, height: 250)]
            )
            switch validSize {
            case 1: return "R-M-DEMO-728x90"
            case 2: return "R-M-DEMO-300x250"
            default: return "R-M-DEMO-adaptive-sticky"
            }
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension BannerAgent: YMAAdViewDelegate {
        func viewControllerForPresentingModalView() -> UIViewController! {
            return rootViewController
        }

        func adViewDidLoad(_ adView: YMAAdView!) {
            onAdLoaded()
        }

        func adViewDidFailLoading(_ adView: YMAAdView!, error: Error!) {
            if let error = error as NSError? {
                if error.code == YMAAdErrorCode.noFill.rawValue {
                    onAdFailedToLoad("No Fill")
                } else {
                    onAdFailedToLoad("\(error)")
                }
            } else {
                onAdFailedToLoad("Unknown")
            }
        }

        func adViewWillLeaveApplication(_ adView: YMAAdView!) {
            onAdClicked()
        }
    }

    private class InterstitialAgent: CASAgent {
        private let placement: String
        private var view: YMAInterstitialController?

        init(placement: String) {
            self.placement = placement
            super.init()
        }

        override var versionInfo: String {
            return YMAMobileAds.sdkVersion()
        }

        override func requestAd() throws {
            guard let newView = YMAInterstitialController(blockID: placement) else {
                onAdFailedToLoad("Cant create instance")
                return
            }
            newView.shouldOpenLinksInApp = true
            newView.delegate = self
            view = newView
            newView.load()
        }

        override func isAdReady() -> Bool {
            return view?.loaded == true && super.isAdReady()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = view else {
                throw CASError.nilOptional("View")
            }
            view.presentInterstitial(from: controller)
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension InterstitialAgent: YMAInterstitialDelegate {
        func interstitialDidLoadAd(_ interstitial: YMAInterstitialController!) {
            onAdLoaded()
        }
        
        func interstitialDidFail(toLoadAd interstitial: YMAInterstitialController!, error: Error!) {
            if let error = error as NSError? {
                if error.code == YMAAdErrorCode.noFill.rawValue {
                    onAdFailedToLoad("No Fill")
                } else {
                    onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
                }
            } else {
                onAdFailedToLoad("Unknown")
            }
        }

        func interstitialDidFail(toPresentAd interstitial: YMAInterstitialController!, error: Error!) {
            if let error = error as NSError? {
                showFailed("\(error.localizedDescription) Code: \(error.code)")
            } else {
                showFailed("Unknown")
            }
        }

        func interstitialWillAppear(_ interstitial: YMAInterstitialController!) {
            onAdShown()
        }

        func interstitialWillLeaveApplication(_ interstitial: YMAInterstitialController!) {
            onAdClicked()
        }

        func interstitialWillDisappear(_ interstitial: YMAInterstitialController!) {
            onAdWillClose()
        }

        func interstitialDidDisappear(_ interstitial: YMAInterstitialController!) {
            onAdClosed()
        }
    }

    private class RewardedAgent: CASAgent {
        private let placement: String
        private var view: YMARewardedAd?

        init(placement: String) {
            self.placement = placement
            super.init()
        }

        override var versionInfo: String {
            return YMAMobileAds.sdkVersion()
        }

        override func requestAd() throws {
            guard let newView = YMARewardedAd(blockID: placement) else {
                onAdFailedToLoad("Cant create instance")
                return
            }
            newView.shouldOpenLinksInApp = true
            newView.delegate = self
            view = newView
            newView.load()
        }

        override func isAdReady() -> Bool {
            return view?.loaded == true && super.isAdReady()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = view else {
                throw CASError.nilOptional("View")
            }
            view.present(from: controller)
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension RewardedAgent: YMARewardedAdDelegate {
        func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd!) {
            onAdLoaded()
        }

        func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd!, error: Error!) {
            if let error = error as NSError? {
                if error.code == YMAAdErrorCode.noFill.rawValue {
                    onAdFailedToLoad("No Fill")
                } else {
                    onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
                }
            } else {
                onAdFailedToLoad("Unknown")
            }
        }

        func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd!, error: Error!) {
            // YMAAdErrorCode
            if let error = error as NSError? {
                showFailed("\(error.localizedDescription) Code: \(error.code)")
            } else {
                showFailed("Unknown")
            }
        }

        func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd!) {
            onAdShown()
        }

        func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd!) {
            onAdClicked()
        }

        func rewardedAd(_ rewardedAd: YMARewardedAd!, didReward reward: YMAReward!) {
            onAdCompleted()
        }

        func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd!) {
            onAdWillClose()
        }

        func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd!) {
            onAdClosed()
        }
    }
#endif
