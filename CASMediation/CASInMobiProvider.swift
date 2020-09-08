//
//  InMobiProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(InMobiSDK)
    import CleverAdsSolutions
    import Foundation
    import InMobiSDK

    final class CASInMobiProvider: NSObject, CASProvider {
        private weak var wrapper: CASMediationWrapper?
        private var bannerRTBMode = false
        private var interRTBMode = false
        private var rewardRTBMode = false

        func getVersionAndVerify() throws -> String {
            if NSClassFromString("IMSdk") == nil {
                throw CASError.notImplemented
            }
            return IMSdk.getVersion()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            if wrapper.appID.isEmpty {
                wrapper.setAppID(try info.readString(
                    forKey: "AccountID",
                    "3827b83fea2a45f68676baecd1cec7a1" /* DemoApp own InMobi */,
                    ""
                ))
            }

            if info.isDemo || (!bannerRTBMode && info.settings.contains("banner_rtb")) {
                bannerRTBMode = true
            }

            if info.isDemo || (!interRTBMode && info.isDemo && info.settings.contains("inter_rtb")) {
                interRTBMode = true
            }

            if info.isDemo || (!rewardRTBMode && info.isDemo && info.settings.contains("reward_rtb")) {
                rewardRTBMode = true
            }
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            self.wrapper = wrapper
            if wrapper.appID.isEmpty {
                wrapper.onInitialized(success: false, "Empty account ID")
                return
            }

            wrapper.settings.appendOptionChanged(delegate: self)

            onChangedDebugMode(wrapper.settings.isDebugMode())
            onChangedMuteAdSounds(wrapper.settings.isMutedAdSounds())
            onChangedTagged(audience: wrapper.settings.getTaggedAudience())

            IMSdk.initWithAccountID(
                wrapper.appID,
                consentDictionary: createConsentObject(wrapper.settings.getUserConsent())
            ) { error in
                if let error = error {
                    wrapper.onInitialized(success: false, error.localizedDescription)
                } else {
                    wrapper.onInitialized(success: true, "")
                }
            }
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(
                placementId: try info.readLong(
                    forKey: bannerRTBMode ? "banner_rtb" : "banner_PlacementID",
                    1598693806103, // DemoAppIOS own InMobi
                    nil
                ),
                rtbMode: bannerRTBMode
            )
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                placementId: try info.readLong(
                    forKey: interRTBMode ? "inter_rtb" : "inter_PlacementID",
                    1599064232253, // DemoAppIOS own InMobi
                    nil),
                rtbMode: interRTBMode
            )
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                placementId: try info.readLong(
                    forKey: rewardRTBMode ? "reward_rtb" : "reward_PlacementID",
                    1597285108391, // DemoAppIOS own InMobi
                    nil),
                rtbMode: rewardRTBMode
            )
        }

        private func createConsentObject(_ gdpr: CASConsentStatus) -> [String: String]? {
            if gdpr == .undefined {
                return nil
            }
            var consentDict = [String: String]()
            consentDict["gdpr"] = "1"
            consentDict[IM_GDPR_CONSENT_AVAILABLE] = gdpr == .accepted ? "true" : "false"
            return consentDict
        }
    }

    extension CASInMobiProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {
            IMSdk.updateGDPRConsent(createConsentObject(gdpr))
        }

        func onChangedState(ccpa: CASCCPAStatus) {
        }

        func onChangedTagged(audience: CASAudience) {
            if audience == .children {
                IMSdk.setAgeGroup(.below18)
                IMSdk.setEducation(.highSchoolOrLess)
            }
        }

        func onChangedDebugMode(_ debug: Bool) {
            IMSdk.setLogLevel(debug ? .debug : .error)
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
            IMSdk.setMute(muted)
        }
    }

    private class BannerAgent: CASBannerAgent {
        let placementId: Int64
        let rtbMode: Bool
        var adReceived = false
        private var view: IMBanner?

        init(placementId: Int64, rtbMode: Bool) {
            self.placementId = placementId
            self.rtbMode = rtbMode
            super.init(true, 3)
        }

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String {
            return IMSdk.getVersion()
        }

        override func requestAd() throws {
            // Supported sizes
            // 320 x 50
            // 300 x 250
            // 728 x 90

            if !validateSize() {
                return
            }
            if isAdReady() {
                onAdLoaded()
                return
            }

            CASHandler.main { [weak self] in
                self?.createBanner()
            }

            try super.requestAd()
        }

        private func createBanner() {
            if let banner = view {
                load(banner: banner)
                return
            }

            guard let banner =
                IMBanner(frame: CGRect(origin: CGPoint.zero, size: loadedSize.toCGSize()),
                         placementId: placementId,
                         delegate: self
                ) else {
                onAdFailedToLoad("Instance can't be created!")
                return
            }
            banner.shouldAutoRefresh(false)
            banner.transitionAnimation = .none
            view = banner
            adReceived = false
            load(banner: banner)
        }

        private func load(banner: IMBanner) {
            let childTag = adSettings.getTaggedAudience()
            if childTag != .mixed {
                banner.extras = ["coppa": childTag == .children ? "1" : "0"]
            }

            if rtbMode {
                if adReceived {
                    banner.preloadManager.load()
                } else {
                    banner.preloadManager.preload()
                }
            } else {
                banner.load()
            }
        }

        override func disposeAd() {
            super.disposeAd()
            view?.delegate = nil
            view = nil
            adReceived = false
        }
    }

    extension BannerAgent: IMBannerDelegate {
        func bannerDidFinishLoading(_ banner: IMBanner!) {
            onAdLoaded()
        }

        func banner(_ banner: IMBanner!, didFailToLoadWithError error: IMRequestStatus!) {
            adReceived = false
            switch error.code {
            case IMStatusCode.noFill.rawValue: onAdFailedToLoad("No Fill")
            case IMStatusCode.earlyRefreshRequest.rawValue:
                onAdFailedToLoad("The Ad Request cannot be done so frequently", 5.0)
            case IMStatusCode.requestTimedOut.rawValue:
                onAdFailedToLoad("Poor internet connection", 10.0)
            default:
                onAdFailedToLoad(error.localizedDescription)
            }
        }

        func banner(_ banner: IMBanner!, didReceiveWith info: IMAdMetaInfo!) {
            if rtbMode {
                let newCPM = info.getBid()
                if newCPM > 0.0 {
                    adReceived = true
                    onEcpmChanged(newCPM)
                    onAdFailedToLoad("Wait continue", 0.0)
                } else {
                    onAdFailedToLoad("Loaded but failed to Fetch CPM")
                }
            }
        }

        func banner(_ banner: IMBanner!, didFailToReceiveWithError error: IMRequestStatus!) {
            self.banner(banner, didFailToLoadWithError: error)
        }

        func banner(_ banner: IMBanner!, didInteractWithParams params: [AnyHashable: Any]!) {
            onAdClicked()
        }
    }

    private class InterstitialAgent: CASAgent {
        let placementId: Int64
        let rtbMode: Bool
        var adReceived = false
        private var view: IMInterstitial?

        init(placementId: Int64, rtbMode: Bool) {
            self.placementId = placementId
            self.rtbMode = rtbMode
            super.init()
        }

        override var versionInfo: String {
            return IMSdk.getVersion()
        }

        override func requestAd() throws {
            CASHandler.main {
                self.loadInter()
            }
        }

        private func loadInter() {
            let inter: IMInterstitial
            if let last = view {
                inter = last
            } else {
                guard let newView = IMInterstitial(placementId: placementId, delegate: self) else {
                    onAdFailedToLoad("Instance can't be created!")
                    return
                }
                view = newView
                inter = newView
            }

            let childTag = adSettings.getTaggedAudience()
            if childTag != .mixed {
                inter.extras = ["coppa": childTag == .children ? "1" : "0"]
            }

            if rtbMode {
                if adReceived {
                    inter.preloadManager.load()
                } else {
                    inter.preloadManager.preload()
                }
            } else {
                inter.load()
            }
        }

        override func isAdReady() -> Bool {
            return view?.isReady() == true
        }

        override func isAdCached() -> Bool {
            return view != nil && super.isAdCached()
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let inter = view else {
                throw CASError.nilOptional("View")
            }
            inter.show(from: controller, with: .coverVertical)
        }

        override func disposeAd() {
            if !adReceived {
                super.disposeAd()
                view?.delegate = nil
                view = nil
            }
        }
    }

    extension InterstitialAgent: IMInterstitialDelegate {
        func interstitialDidFinishLoading(_ interstitial: IMInterstitial!) {
            onAdLoaded()
        }

        func interstitial(_ interstitial: IMInterstitial!, didFailToLoadWithError error: IMRequestStatus!) {
            adReceived = false
            switch error.code {
            case IMStatusCode.noFill.rawValue: onAdFailedToLoad("No Fill")
            case IMStatusCode.earlyRefreshRequest.rawValue:
                onAdFailedToLoad("The Ad Request cannot be done so frequently", 5.0)
            case IMStatusCode.requestTimedOut.rawValue:
                onAdFailedToLoad("Poor internet connection", 10.0)
            default:
                onAdFailedToLoad(error.localizedDescription)
            }
        }

        func interstitial(_ interstitial: IMInterstitial!, didReceiveWith metaInfo: IMAdMetaInfo!) {
            if rtbMode {
                let newCPM = metaInfo.getBid()
                if newCPM > 0.0 {
                    adReceived = true
                    onEcpmChanged(newCPM)
                    onAdFailedToLoad("Wait continue", 0.0)
                } else {
                    onAdFailedToLoad("Loaded but failed to Fetch CPM")
                }
            }
        }

        func interstitial(_ interstitial: IMInterstitial!, didFailToReceiveWithError error: Error!) {
            adReceived = false
            onAdFailedToLoad(error.localizedDescription)
        }

        func interstitialWillPresent(_ interstitial: IMInterstitial!) {
            onAdShown()
        }

        func interstitial(_ interstitial: IMInterstitial!, didFailToPresentWithError error: IMRequestStatus!) {
            showFailed(error.localizedDescription)
        }

        func interstitialWillDismiss(_ interstitial: IMInterstitial!) {
            onAdWillClose()
        }

        func interstitialDidDismiss(_ interstitial: IMInterstitial!) {
            adReceived = false
            onAdClosed()
        }

        func interstitial(_ interstitial: IMInterstitial!, didInteractWithParams params: [AnyHashable: Any]!) {
            onAdClicked()
        }

        func interstitial(_ interstitial: IMInterstitial!, rewardActionCompletedWithRewards rewards: [AnyHashable: Any]!) {
            if !rewards.isEmpty {
                onAdCompleted()
            }
        }
    }
#endif
