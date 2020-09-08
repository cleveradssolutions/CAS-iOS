//
//  AdColonyProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(AdColony)
    import AdColony
    import CleverAdsSolutions
    import Foundation

    private let demoAppId = "appbdee68ae27024084bb334a"
    private let demoBannerId = "vz77f5db656e2840c4ab"
    private let demoInterId = "vzf8fb4670a60e4a139d01b5"
    private let demoRewardId = "vzf8e4e97704c4445c87504e"

    final class CASAdColonyProvider: NSObject, CASProvider {
        private var allZones = Set<String>()

        func getVersionAndVerify() throws -> String {
            if NSClassFromString("AdColony") == nil {
                throw CASError.notImplemented
            }
            return AdColony.getSDKVersion()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            let param: [String: Any]
            if info.isDemo {
                param = ["appId": demoAppId,
                         "banner_Id": demoBannerId,
                         "inter_Id": demoInterId,
                         "reward_Id": demoRewardId]
            } else {
                param = try info.readSettings()
            }
            if let bannerId = param["banner_Id"] as? String {
                allZones.insert(bannerId)
            }
            if let interId = param["inter_Id"] as? String {
                allZones.insert(interId)
            }
            if let rewardID = param["reward_Id"] as? String {
                allZones.insert(rewardID)
            }
            if wrapper.appID.isEmpty, let appID = param["appId"] as? String {
                wrapper.setAppID(appID)
            }
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            if wrapper.appID.isEmpty {
                wrapper.onInitialized(success: false, "App ID Not found")
                return
            }

            if allZones.isEmpty {
                wrapper.onInitialized(success: false, "Have no zones")
                return
            }

            wrapper.settings.appendOptionChanged(delegate: self)

            let appOptions = AdColonyAppOptions()
            appOptions.testMode = wrapper.isDemoAdMode || wrapper.appID == demoAppId

            let consent = wrapper.settings.getUserConsent()
            appOptions.setPrivacyFrameworkOfType(ADC_GDPR, isRequired: consent != .undefined)
            appOptions.setPrivacyConsentString((consent == .accepted) ? "1" : "0", forType: ADC_GDPR)

            let doNotSell = wrapper.settings.getDoNotSell()
            appOptions.setPrivacyFrameworkOfType(ADC_CCPA, isRequired: doNotSell != .undefined)
            appOptions.setPrivacyConsentString((doNotSell == .optInSale) ? "1" : "0", forType: ADC_CCPA)

            appOptions.disableLogging = !wrapper.settings.isDebugMode()

            AdColony.configure(withAppID: wrapper.appID,
                               zoneIDs: Array(allZones),
                               options: appOptions) { _ in
                wrapper.onInitializeDelayed()
            }

            // AdColony.setRewardListener(self) // After configure
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(zone: try info.readString(forKey: "banner_Id", demoBannerId, nil))
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                zone: try info.readString(forKey: "inter_Id", demoInterId, nil),
                likeRewarded: false
            )
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                zone: try info.readString(forKey: "reward_Id", demoRewardId, nil),
                likeRewarded: true
            )
        }
    }

    extension CASAdColonyProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {
            guard let options = AdColony.getAppOptions() else { return }

            options.setPrivacyFrameworkOfType(ADC_GDPR, isRequired: gdpr != .undefined)
            options.setPrivacyConsentString((gdpr == .accepted) ? "1" : "0", forType: ADC_GDPR)

            AdColony.setAppOptions(options)
        }

        func onChangedState(ccpa: CASCCPAStatus) {
            guard let options = AdColony.getAppOptions() else { return }

            options.setPrivacyFrameworkOfType(ADC_CCPA, isRequired: ccpa != .undefined)
            options.setPrivacyConsentString((ccpa == .optInSale) ? "1" : "0", forType: ADC_CCPA)

            AdColony.setAppOptions(options)
        }

        func onChangedTagged(audience: CASAudience) {
            // Should enabled only in USA COPPA
            //        val options: AdColonyAppOptions = AdColony.getAppOptions() ?: return
            //
            //        options.setPrivacyFrameworkRequired(AdColonyAppOptions.COPPA, forChildren == true)
            //
            //        AdColony.setAppOptions(options)
        }

        func onChangedDebugMode(_ debug: Bool) {
            guard let options = AdColony.getAppOptions() else { return }
            options.disableLogging = !debug
            AdColony.setAppOptions(options)
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
        }
    }

    private class BannerAgent: CASBannerAgent {
        private let zone: String
        private var view: AdColonyAdView?
        private var container: UIView?

        init(zone: String) {
            self.zone = zone
            super.init(true, 3)
        }

        override var versionInfo: String {
            return AdColony.getSDKVersion()
        }

        override func getView() -> UIView? {
            return container
        }

        override func requestAd() throws {
            if rootViewController == nil {
                // On Ad Failed called from getter
                return
            }
            if loadedSize != size || loadedSizeIndex < 0 {
                let validSize = findClosestSize([
                    CGSize(width: 320, height: 50),
                    CGSize(width: 728, height: 90),
                    CGSize(width: 300, height: 250),
                    // CGSize(width: 160, height: 600)
                ])

                if validSize < 0 {
                    return
                }
            }

            if isAdReady() {
                onAdLoaded()
                return
            }

            CASHandler.main {
                self.requestBanner()
            }
            try super.requestAd()
        }

        private func requestBanner() {
            guard let rootController = rootViewController else {
                // On Ad Failed called from getter
                return
            }
            let acSize: AdColonyAdSize
            switch loadedSizeIndex {
            case 0: acSize = kAdColonyAdSizeBanner
            case 1: acSize = kAdColonyAdSizeLeaderboard
            case 2: acSize = kAdColonyAdSizeMediumRectangle
            // case 3: acSize = kAdColonyAdSizeSkyscraper
            default:
                onAdWrongSize()
                return
            }

            AdColony.requestAdView(inZone: zone, with: acSize, viewController: rootController, andDelegate: self)
        }

        override func isAdCached() -> Bool {
            return view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = self.view else {
                throw CASError.nilOptional("View")
            }
            guard let container = container else {
                throw CASError.nilOptional("Container")
            }
            try super.showAd(controller)
            container.addSubview(view)
        }

        override func hideAd() {
            if let view = view {
                view.removeFromSuperview()
            }
            super.hideAd()
        }

        override func disposeAd() {
            super.disposeAd()
            destroyMainThread(target: view)
            view?.delegate = nil
            view = nil
        }

        override func onDestroyMainThread(_ target: Any) {
            if let view = target as? AdColonyAdView {
                view.destroy()
            }
            super.onDestroyMainThread(target)
        }

        override func onRefreshed() -> Float {
            disposeAd()
            return super.onRefreshed()
        }
    }

    extension BannerAgent: AdColonyAdViewDelegate {
        func adColonyAdViewDidLoad(_ adView: AdColonyAdView) {
            if adView.zoneID == zone {
                view = adView
                if container == nil {
                    container = UIView(frame: CGRect.zero)
                }
                onAdLoaded()
            }
        }

        func adColonyAdViewDidFail(toLoad error: AdColonyAdRequestError) {
            if error.zoneId == zone {
                view = nil
                if error.code == AdColonyRequestError.noFillForRequest.rawValue {
                    onAdFailedToLoad("No Fill")
                } else {
                    onAdFailedToLoad(error.description)
                }
            }
        }

        func adColonyAdViewWillLeaveApplication(_ adView: AdColonyAdView) {
            if adView.zoneID == zone {
                onAdClicked()
            }
        }
    }

    private class InterstitialAgent: CASAgent {
        private let zone: String
        private let likeRewarded: Bool
        private var view: AdColonyInterstitial?

        init(zone: String, likeRewarded: Bool) {
            self.zone = zone
            self.likeRewarded = likeRewarded
            super.init()
        }

        override var versionInfo: String {
            return AdColony.getSDKVersion()
        }

        override func requestAd() throws {
            AdColony.requestInterstitial(inZone: zone, options: nil, andDelegate: self)
        }

        override func isAdCached() -> Bool {
            return view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let view = view else {
                throw CASError.nilOptional("View")
            }
            if likeRewarded, let zone = AdColony.zone(forID: self.zone) {
                zone.setReward { [weak self] succses, _, _ in
                    guard let agent = self else {
                        Debug.logError("AdColony Rewarded agent removed from memory but Reward callback still connected.")
                        zone.setReward(nil)
                        return
                    }
                    if succses {
                        agent.onAdCompleted()
                    } else {
                        agent.log("Reward not received")
                    }
                }
            }

            view.show(withPresenting: controller)
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
        }
    }

    extension InterstitialAgent: AdColonyInterstitialDelegate {
        func adColonyInterstitialDidLoad(_ interstitial: AdColonyInterstitial) {
            if interstitial.zoneID == zone {
                if likeRewarded, let acZone = AdColony.zone(forID: self.zone), !acZone.rewarded {
                    onAdFailedToLoad("Zone used for rewarded video is not a rewarded video zone", 600.0)
                    return
                }
                view = interstitial
                onAdLoaded()
            }
        }

        func adColonyInterstitialDidFail(toLoad error: AdColonyAdRequestError) {
            if error.zoneId == zone {
                view = nil
                if error.code == AdColonyRequestError.noFillForRequest.rawValue {
                    onAdFailedToLoad("No Fill")
                } else {
                    onAdFailedToLoad(error.description)
                }
            }
        }

        func adColonyInterstitialExpired(_ interstitial: AdColonyInterstitial) {
            if interstitial.zoneID == zone {
                view = nil
                onAdFailedToLoad("Content expiring", 1.0)
            }
        }

        func adColonyInterstitialWillOpen(_ interstitial: AdColonyInterstitial) {
            if interstitial.zoneID == zone {
                onAdShown()
            }
        }

        func adColonyInterstitialWillLeaveApplication(_ interstitial: AdColonyInterstitial) {
            if interstitial.zoneID == zone {
                onAdClicked()
            }
        }

        func adColonyInterstitialDidClose(_ interstitial: AdColonyInterstitial) {
            if interstitial.zoneID == zone {
                if likeRewarded, let acZone = AdColony.zone(forID: self.zone) {
                    acZone.setReward(nil)
                }
                onAdWillClose()
                onAdClosed()
            }
        }
    }
#endif
