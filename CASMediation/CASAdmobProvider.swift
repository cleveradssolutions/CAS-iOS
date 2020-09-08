//
//  AdmobProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(GoogleMobileAds)
    import CleverAdsSolutions
    import Foundation
    import GoogleMobileAds

    final class CASAdmobProvider: NSObject, CASProvider {
        func getVersionAndVerify() throws -> String {
            // print("ClassCAS: \(NSStringFromClass(GADMobileAds.self))")
            if NSClassFromString("GADMobileAds") == nil {
                throw CASError.notImplemented
            }
            return GADMobileAds.sharedInstance().sdkVersion
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
            let instance = GADMobileAds.sharedInstance()
            let config = instance.requestConfiguration
            applyPrivacyLimits(config, wrapper.settings.getTaggedAudience())
            onChangedState(ccpa: wrapper.settings.getDoNotSell())

            if wrapper.settings.getTestDeviceIDs().count > 0 {
                config.testDeviceIdentifiers = wrapper.settings.getTestDeviceIDs()
            }

            wrapper.settings.appendOptionChanged(delegate: self)
            GADMobileAds.sharedInstance().disableMediationInitialization()

            instance.start { _ in
                wrapper.onInitialized(success: true, "")
                GADMobileAds.sharedInstance().applicationMuted = wrapper.settings.isMutedAdSounds()
            }
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(for:
                try info.readString(forKey: "banner_AdUnit", "ca-app-pub-3940256099942544/2934735716", nil))
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(for:
                try info.readString(forKey: "inter_AdUnit", "ca-app-pub-3940256099942544/4411468910", nil))
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return RewardedAgent(for:
                try info.readString(forKey: "reward_AdUnit", "ca-app-pub-3940256099942544/1712485313", nil))
        }
    }

    extension CASAdmobProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {}

        func onChangedState(ccpa: CASCCPAStatus) {
            if ccpa == .undefined {
                UserDefaults.standard.removeObject(forKey: "gad_rdp")
            } else {
                UserDefaults.standard.set(ccpa == .optOutSale, forKey: "gad_rdp")
            }
        }

        func onChangedTagged(audience: CASAudience) {
            let config = GADMobileAds.sharedInstance().requestConfiguration
            applyPrivacyLimits(config, audience)
        }

        func onChangedDebugMode(_ debug: Bool) {}

        func onChangedMuteAdSounds(_ muted: Bool) {
            GADMobileAds.sharedInstance().applicationMuted = muted
        }

        private func applyPrivacyLimits(_ config: GADRequestConfiguration, _ audience: CASAudience) {
            if audience == .children {
                config.tag(forChildDirectedTreatment: true)
                config.tagForUnderAge(ofConsent: true)
            } else {
                config.tag(forChildDirectedTreatment: false)
                config.tagForUnderAge(ofConsent: false)
            }
        }
    }

    extension CASAdmobProvider {
        static func createRequest(_ settings: CASSettings) -> GADRequest {
            let result = GADRequest()
            if settings.getUserConsent() == .denied {
                let extras = GADExtras()
                extras.additionalParameters = ["npa": "1"]
                result.register(extras)
            }
            return result
        }

        static func convert(size: CASSize) -> GADAdSize {
            if size == CASSize.banner {
                return kGADAdSizeBanner
            } else if size.isAdaptive {
                return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(CGFloat(size.width))
            } else if size == CASSize.leaderboard {
                return kGADAdSizeLeaderboard
            } else if size == CASSize.mediumRectangle {
                return kGADAdSizeMediumRectangle
            }
            return kGADAdSizeBanner
        }
    }

    private final class BannerAgent: CASBannerAgent {
        private let adUnit: String
        private var view: GADBannerView?

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String { return GADMobileAds.sharedInstance().sdkVersion }

        init(for adUnit: String) {
            self.adUnit = adUnit
            super.init(false, 3)
        }

        override func requestAd() throws {
            if rootViewController == nil {
                // On Ad Failed called from getter
                return
            }
            if view == nil || size != loadedSize {
                disposeAd()
                try super.requestAd()
                loadedSize = size
                CASHandler.main {
                    self.createView()
                }
                return
            }
            if isAdReady() {
                onAdLoaded()
                return
            } /* else {
             */ /* If your ad fails to load, you don't need to explicitly request another one as long as you've configured your ad unit to refresh.
             * The Google Mobile Ads SDK respects any refresh rate you specified in the Ad Manager UI.
             * If you haven't enabled refresh, you will need to issue a new request.
             */ /*
                 onAdFailedToLoad(this, AdRequest.ERROR_CODE_NO_FILL)
             }*/

            CASHandler.main {
                if let banner = self.view {
                    banner.delegate = self
                    banner.rootViewController = self.rootViewController
                    banner.load(CASAdmobProvider.createRequest(self.adSettings))
                } else {
                    self.onAdFailedToLoad("View not created")
                }
            }
            try super.requestAd() // Not supported internal Refresh timer reset
        }

        private func createView() {
            guard let rootController: UIViewController = rootViewController else {
                // On Ad Failed called from getter
                return
            }
            let newView = GADBannerView(adSize: CASAdmobProvider.convert(size: size))
            newView.isAutoloadEnabled = false
            newView.adUnitID = adUnit
            newView.rootViewController = rootController
            newView.delegate = self
            newView.load(CASAdmobProvider.createRequest(adSettings))
            view = newView
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let banner = view else {
                throw CASError.nilOptional("View")
            }
            banner.rootViewController = controller
            refreshable = isOverpriced || adSettings.getBannerRefreshInterval() != 30
            try super.showAd(controller)
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension BannerAgent: GADBannerViewDelegate {
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            onAdLoaded()
        }

        func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
            if error.code == GADErrorCode.noFill.rawValue {
                onAdFailedToLoad("No Fill")
            } else {
                onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
            }
        }

        func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
            onAdClicked()
        }
    }

    private final class InterstitialAgent: CASAgent {
        private let adUnit: String
        private var view: GADInterstitial?

        override var versionInfo: String { return GADMobileAds.sharedInstance().sdkVersion }

        init(for adUnit: String) {
            self.adUnit = adUnit
            super.init()
        }

        override func isAdReady() -> Bool { return view != nil && checkAdReadyMainThread() }
        override func isAdReadyMainThread() -> Bool { return view?.isReady == true }
        override func isAdCached() -> Bool { return view != nil && super.isAdCached() }

        override func requestAd() {
            let newTarget = GADInterstitial(adUnitID: adUnit)
            view = newTarget
            newTarget.delegate = self

            CASHandler.main {
                newTarget.load(CASAdmobProvider.createRequest(self.adSettings))
            }
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let target = view else {
                throw CASError.nilOptional("View")
            }
            target.present(fromRootViewController: controller)
        }

        override func disposeAd() {
            view?.delegate = nil
            view = nil
            super.disposeAd()
        }
    }

    extension InterstitialAgent: GADInterstitialDelegate {
        func interstitialDidReceiveAd(_ ad: GADInterstitial) {
            onAdLoaded()
        }

        func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
            if error.code == GADErrorCode.noFill.rawValue {
                onAdFailedToLoad("No Fill")
            } else {
                onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
            }
        }

        func interstitialWillDismissScreen(_ ad: GADInterstitial) {
            onAdWillClose()
        }

        func interstitialDidDismissScreen(_ ad: GADInterstitial) {
            onAdClosed()
        }

        func interstitialWillPresentScreen(_ ad: GADInterstitial) {
            onAdShown()
        }

        func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
            onAdClicked()
        }

        func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
            showFailed("Uncnown", 0)
        }
    }

    private final class RewardedAgent: CASAgent {
        private let adUnit: String
        private var view: GADRewardedAd?

        override var versionInfo: String { return GADMobileAds.sharedInstance().sdkVersion }

        init(for adUnit: String) {
            self.adUnit = adUnit
            super.init()
        }

        override func isAdReady() -> Bool { return view != nil && checkAdReadyMainThread() }
        override func isAdReadyMainThread() -> Bool { return view?.isReady == true }
        override func isAdCached() -> Bool { return view != nil && super.isAdCached() }

        override func requestAd() throws {
            let newTarget = GADRewardedAd(adUnitID: adUnit)
            view = newTarget

            CASHandler.main {
                newTarget.load(CASAdmobProvider.createRequest(self.adSettings)) { [weak self] error in
                    if let error = error {
                        if error.code == GADErrorCode.noFill.rawValue {
                            self?.onAdFailedToLoad("No Fill")
                        } else {
                            self?.onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
                        }
                    } else {
                        self?.onAdLoaded()
                    }
                }
            }
            return
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let target = view else {
                throw CASError.nilOptional("View")
            }
            target.present(fromRootViewController: controller, delegate: self)
        }

        override func disposeAd() {
            view = nil
            super.disposeAd()
        }
    }

    extension RewardedAgent: GADRewardedAdDelegate {
        func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
            onAdWillClose()
            onAdClosed()
        }

        func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
            onAdCompleted()
        }

        func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
            onAdShown()
        }

        func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
            let nsError = error as NSError
            showFailed("\(nsError.localizedDescription) Code: \(nsError.code)")
        }
    }
#endif
