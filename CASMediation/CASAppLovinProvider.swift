//
//  AppLovinProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(AdColony)
    import AppLovinSDK
    import CleverAdsSolutions
    import Foundation

    final class CASAppLovinProvider: NSObject, CASProvider {
        private var sdk: ALSdk?
        private weak var delegate: CASMediationWrapper?

        func getVersionAndVerify() throws -> String {
            if NSClassFromString("ALSdk") == nil {
                throw CASError.notImplemented
            }
            return ALSdk.version()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)
            if wrapper.appID.isEmpty {
                let defVal = "TxhDiMQVbncc9h4M1QzqCMODZz7gMzTwuF8bbT6CKipTPuqQJoFV8dihbrNzpxthA0ImTOyt6mLWeAxyyBS5q9"
                wrapper.setAppID(
                    try info.readString(forKey: "SDK_KEY", defVal, "") // Demo by office@clearinvest-ltd.com
                )
            }
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            delegate = wrapper
            if wrapper.appID.isEmpty {
                wrapper.onInitialized(success: false, "SDK Key Not found")
                return
            }

            wrapper.settings.appendOptionChanged(delegate: self)

            let consent = wrapper.settings.getUserConsent()
            if consent != .undefined {
                onChangedState(gdpr: consent)
            }
            let doNotSell = wrapper.settings.getCCPAStatus()
            if doNotSell != .undefined {
                onChangedState(ccpa: doNotSell)
            }
            let audience = wrapper.settings.getTaggedAudience()
            if audience != .undefined {
                onChangedTagged(audience: audience)
            }

            let settings = ALSdkSettings()
            settings.muted = wrapper.settings.isMutedAdSounds()
            // Lot of debug informaion
            //settings.isVerboseLogging = wrapper.settings.isDebugMode()

            if !wrapper.settings.getTestDeviceIDs().isEmpty {
                settings.testDeviceAdvertisingIdentifiers = wrapper.settings.getTestDeviceIDs()
            }

            sdk = ALSdk.shared(withKey: wrapper.appID, settings: settings)
            sdk!.initializeSdk { _ in
                wrapper.onInitializeDelayed()
            }
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            guard let sdk = sdk else {
                throw CASError.nilOptional("SDK")
            }
            let zone = try info.readString(forKey: "banner_zoneID", "", "")
            return BannerAgent(zone: zone, sdk: sdk)
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            guard let sdk = sdk else {
                throw CASError.nilOptional("SDK")
            }
            let zone = try info.readString(forKey: "inter_zoneID", "", "") // 081b0dfd806f88e2
            return InterstitialAgent(zone: zone, sdk: sdk)
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            guard let sdk = sdk else {
                throw CASError.nilOptional("SDK")
            }
            let zone = try info.readString(forKey: "reward_zoneID", "", "")
            return RewardedAgent(zone: zone, sdk: sdk)
        }
    }

    extension CASAppLovinProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {
            ALPrivacySettings.setHasUserConsent(gdpr == .accepted)
        }

        func onChangedState(ccpa: CASCCPAStatus) {
            ALPrivacySettings.setDoNotSell(ccpa == .undefined || ccpa == .optOutSale)
        }

        func onChangedTagged(audience: CASAudience) {
            ALPrivacySettings.setIsAgeRestrictedUser(audience == .children)
        }

        func onChangedDebugMode(_ debug: Bool) {
            // Lot of debug info
            //sdk?.settings.isVerboseLogging = debug
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
            sdk?.settings.muted = muted
        }
    }

    private class AdDelegate: NSObject, ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate {
        weak var agent: CASAgent?
        var view: ALAd?

        // MARK: ALAdLoadDelegate

        func adService(_ adService: ALAdService, didLoad ad: ALAd) {
            if let agent = agent {
                view = ad
                agent.onAdLoaded()
            }
        }

        func adService(_ adService: ALAdService, didFailToLoadAdWithError code: Int32) {
            view = nil
            if let agent = agent {
                switch code {
                case kALErrorCodeNoFill: agent.onAdFailedToLoad("No Fill", 60.0)
                case kALErrorCodeAdRequestNetworkTimeout: agent.onAdFailedToLoad("Fetch ad timeout")
                case kALErrorCodeNotConnectedToInternet: agent.onAdFailedToLoad("No net")
                case kALErrorCodeSdkDisabled: agent.onAdFailedToLoad("SDK Disabled", 120.0)
                case kALErrorCodeInvalidZone: agent.onAdFailedToLoad("Invalid Zone", 120.0)
                case kALErrorCodeInvalidURL: agent.onAdFailedToLoad("Invalid URL", 120.0)
                case kALErrorCodeInvalidResponse: agent.onAdFailedToLoad("Invalid response or wrong OS", 120.0)
                default: agent.onAdFailedToLoad("UNSPECIFIED_ERROR \(code)")
                }
            }
        }

        // MARK: ALAdDisplayDelegate

        func ad(_ ad: ALAd, wasDisplayedIn view: UIView) {
            agent?.onAdShown()
        }

        func ad(_ ad: ALAd, wasHiddenIn view: UIView) {
            if let agent = agent {
                agent.onAdWillClose()
                agent.onAdClosed()
            }
        }

        func ad(_ ad: ALAd, wasClickedIn view: UIView) {
            agent?.onAdClicked()
        }

        // MARK: ALAdVideoPlaybackDelegate

        func videoPlaybackBegan(in ad: ALAd) {
        }

        func videoPlaybackEnded(in ad: ALAd, atPlaybackPercent percentPlayed: NSNumber,
                                fullyWatched wasFullyWatched: Bool) {
            if wasFullyWatched {
                agent?.onAdCompleted()
            }
        }
    }

    private class BannerAgent: CASBannerAgent {
        private let zone: String
        private let sdk: ALSdk
        private let adDelegate: AdDelegate

        private var view: ALAdView?

        init(zone: String, sdk: ALSdk) {
            self.zone = zone
            self.sdk = sdk
            adDelegate = AdDelegate()
            super.init(true, 3)
            adDelegate.agent = self
        }

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String {
            return ALSdk.version()
        }

        override func requestAd() throws {
            if !validateSize() {
                return
            }

            if isAdReady() {
                onAdLoaded()
                return
            }

            guard let alSize = getALSize() else { return }

            if zone.isEmpty {
                sdk.adService.loadNextAd(alSize, andNotify: adDelegate)
            } else {
                sdk.adService.loadNextAd(forZoneIdentifier: zone, andNotify: adDelegate)
            }
            try super.requestAd()
        }

        private func getALSize() -> ALAdSize? {
            switch loadedSizeIndex {
            case 0: return ALAdSize.banner
            case 1: return ALAdSize.leader
            case 2: return ALAdSize.mrec // Not supported Zones. Work only Null zone
            default:
                onAdWrongSize()
                return nil
            }
        }

        override func onAdLoaded() {
            guard let ad = adDelegate.view else {
                onAdFailedToLoad("Wrong Ad load event. Ad is nil.")
                return
            }
            if let view = self.view {
                view.render(ad)
                super.onAdLoaded()
            } else {
                CASHandler.main {
                    self.createBanner()
                }
            }
        }

        private func createBanner() {
            guard let alSize = getALSize() else { return }

            let newView: ALAdView = ALAdView(sdk: sdk, size: alSize)
            newView.adLoadDelegate = adDelegate
            newView.adDisplayDelegate = adDelegate
            // newView.adEventDelegate = self
            newView.isAutoloadEnabled = false
            view = newView
            onAdLoaded()
        }

        override func isAdCached() -> Bool {
            return adDelegate.view != nil && super.isAdCached()
        }

        override func disposeAd() {
            super.disposeAd()
            view?.adLoadDelegate = nil
            view?.adDisplayDelegate = nil
            view = nil
            adDelegate.view = nil
        }
    }

    private class InterstitialAgent: CASAgent {
        private let zone: String
        private let sdk: ALSdk
        private let adDelegate: AdDelegate
        private var activeInter: ALInterstitialAd?

        init(zone: String, sdk: ALSdk) {
            self.zone = zone
            self.sdk = sdk
            adDelegate = AdDelegate()
            super.init()
            adDelegate.agent = self
        }

        override var versionInfo: String {
            return ALSdk.version()
        }

        override func requestAd() throws {
            if zone.isEmpty {
                sdk.adService.loadNextAd(ALAdSize.interstitial, andNotify: adDelegate)
            } else {
                sdk.adService.loadNextAd(forZoneIdentifier: zone, andNotify: adDelegate)
            }
        }

        override func isAdCached() -> Bool {
            return adDelegate.view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let ad = adDelegate.view else {
                throw CASError.nilOptional("View Ad")
            }
            let inter = ALInterstitialAd(sdk: sdk)
            inter.adDisplayDelegate = adDelegate
            inter.adVideoPlaybackDelegate = adDelegate
            activeInter = inter // Must be stored until impression! Else instance is free
            inter.show(ad)
        }

        override func onAdClosed() {
            activeInter = nil
            adDelegate.view = nil
            super.onAdClosed()
        }
    }

    private class RewardedAgent: CASAgent {
        private let zone: String
        private let sdk: ALSdk
        private let adDelegate: AdDelegate

        private var dialog: ALIncentivizedInterstitialAd?

        init(zone: String, sdk: ALSdk) {
            self.zone = zone
            self.sdk = sdk
            adDelegate = AdDelegate()
            super.init()
            adDelegate.agent = self
        }

        override var versionInfo: String {
            return ALSdk.version()
        }

        override func requestAd() throws {
            // If this is a default Zone, create the incentivized ad normally.
            if zone.isEmpty {
                // Loading an ad for default zone must be done through zone-agnostic
                // `ALIncentivizedInterstitialAd` instance
                if let dialog = dialog {
                    dialog.preloadAndNotify(adDelegate)
                } else {
                    createDialog().preloadAndNotify(adDelegate)
                }
            } else {
                // If custom zone id
                sdk.adService.loadNextAd(forZoneIdentifier: zone, andNotify: adDelegate)
            }
        }

        private func createDialog() -> ALIncentivizedInterstitialAd {
            let newDialog = ALIncentivizedInterstitialAd(sdk: sdk)
            newDialog.adDisplayDelegate = adDelegate
            newDialog.adVideoPlaybackDelegate = adDelegate
            dialog = newDialog
            return newDialog
        }

        override func isAdCached() -> Bool {
            return adDelegate.view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let ad = adDelegate.view else {
                throw CASError.nilOptional("View Ad")
            }

            if let dialog = dialog {
                dialog.show(ad, andNotify: nil)
            } else if !zone.isEmpty {
                createDialog().show(ad, andNotify: nil)
            } else {
                throw CASError.nilOptional("Dialog")
            }
        }

        override func onAdClosed() {
            adDelegate.view = nil
            super.onAdClosed()
        }
    }
#endif
