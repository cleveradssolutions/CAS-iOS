//
//  UnityAdsProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(UnityAds)
    import CleverAdsSolutions
    import Foundation
    import UnityAds

    final class CASUnityAdsProvider: NSObject, CASProvider {
        private weak var wrapper: CASMediationWrapper?
        private var placementsInUse = [String: CASAgent]()
        fileprivate weak var adShowingAgent: InterstitialAgent?

        func getVersionAndVerify() throws -> String {
            return UnityAds.getVersion()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            if wrapper.appID.isEmpty {
                wrapper.setAppID(try info.readString(forKey: "GameID", "14850", ""))
            }
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            self.wrapper = wrapper
            if wrapper.appID.isEmpty {
                wrapper.onInitialized(success: false, "Game ID Not Found")
                return
            }
            if !UnityAds.isSupported() {
                wrapper.onInitialized(success: false, "Not supported for API")
                return
            }

            let data = UADSMetaData()
            let consent = wrapper.settings.getUserConsent()
            if consent != .undefined {
                data.set("gdpr.consent", value: consent == .accepted)
            }
            let doNotSell = wrapper.settings.getDoNotSell()
            if doNotSell != .undefined {
                data.set("privacy.consent", value: doNotSell == .optInSale)
            }
            data.commit()

            wrapper.settings.appendOptionChanged(delegate: self)

            UnityAds.add(self)
            UnityAds.initialize(wrapper.appID, testMode: wrapper.isDemoAdMode, enablePerPlacementLoad: true)
            wrapper.onInitialized(success: true, "")
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(
                placementId: try info.readString(forKey: "banner_PlacementID", "bannerads", nil),
                provider: self
            )
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                placementId: try info.readString(forKey: "inter_PlacementID", "video", nil),
                provider: self
            )
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return InterstitialAgent(
                placementId: try info.readString(forKey: "reward_PlacementID", "rewardedVideo", nil),
                provider: self
            )
        }
    }

    extension CASUnityAdsProvider: CASOptionsListener {
        func onChangedState(gdpr: CASConsentStatus) {
            let data = UADSMetaData()
            data.set("gdpr.consent", value: gdpr == .accepted)
            data.commit()
        }

        func onChangedState(ccpa: CASCCPAStatus) {
            let data = UADSMetaData()
            data.set("privacy.consent", value: ccpa == .optInSale)
            data.commit()
        }

        func onChangedTagged(audience: CASAudience) {
//        if let forChildren = forChildren {
//            let data = UADSMetaData()
//            data.set("privacy.useroveragelimit", value: !forChildren)
//            data.commit()
//        }
        }

        func onChangedDebugMode(_ debug: Bool) {
            UnityAds.setDebugMode(debug)
        }

        func onChangedMuteAdSounds(_ muted: Bool) {
        }
    }

    extension CASUnityAdsProvider: UnityAdsExtendedDelegate {
        func unityAdsPlacementStateChanged(_ placementId: String,
                                           oldState: UnityAdsPlacementState,
                                           newState: UnityAdsPlacementState) {
            CASHandler.post { [weak self] in
                if let agent = self?.placementsInUse[placementId] {
                    if newState == .noFill {
                        agent.onAdFailedToLoad("No Fill")
                        self?.placementsInUse.removeValue(forKey: placementId)
                    } else if newState == .disabled {
                        agent.onAdFailedToLoad("Disabled placement")
                        self?.placementsInUse.removeValue(forKey: placementId)
                    }
                }
            }
        }

        func unityAdsReady(_ placementId: String) {
            CASHandler.post { [weak self] in
                if let agent = self?.placementsInUse[placementId] {
                    agent.onAdLoaded()
                }
            }
        }

        func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
            switch error {
            case .initializedFailed, .notInitialized, .initSanityCheckFail:
                onInitializeFailed(message, -1.0)
            case .adBlockerDetected, .invalidArgument:
                onInitializeFailed(message, 300.0)
            default:
                adShowingAgent?.showFailed(message)
            }
        }

        func unityAdsDidStart(_ placementId: String) {
            if let agent = adShowingAgent, placementId == agent.placementId {
                agent.onAdShown()
            }
        }

        func unityAdsDidClick(_ placementId: String) {
            if let agent = adShowingAgent, placementId == agent.placementId {
                agent.onAdClicked()
            }
        }

        func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
            if let agent = adShowingAgent {
                adShowingAgent = nil
                CASHandler.post {
                    self.placementsInUse.removeValue(forKey: agent.placementId)
                    if state == .error {
                        // Show failed error called from unityAdsDidError
                    } else {
                        if state == .completed {
                            agent.onAdCompleted()
                        }
                        agent.onAdWillClose()
                        agent.onAdClosed()
                    }
                }
            }
        }
    }

    fileprivate extension CASUnityAdsProvider {
        func loadInterstitialAd(agent: InterstitialAgent) {
            if placementsInUse[agent.placementId] != nil {
                agent.onAdFailedToLoad("An ad is already loading")
                return
            }

            if initializeUnityAds(agent) {
                placementsInUse[agent.placementId] = agent

                if agent.isAdReady() {
                    agent.onAdLoaded()
                } else {
                    UnityAds.load(agent.placementId)
                }
            }
        }

        func initializeUnityAds(_ agent: CASAgent) -> Bool {
            if !UnityAds.isInitialized() {
                if !UnityAds.isSupported() {
                    agent.onAdFailedToLoad("The current device is not supported", 300.0)
                    return false
                }
                guard let wrapper = wrapper else {
                    agent.onAdFailedToLoad("CAS wrapper not found")
                    return false
                }

                wrapper.log("Initialize Unity Ads")
                UnityAds.initialize(wrapper.appID, testMode: wrapper.isDemoAdMode, enablePerPlacementLoad: true)
            }
            return true
        }

        func onInitializeFailed(_ message: String, _ delay: Float) {
            CASHandler.post { [weak self] in
                if let placements = self?.placementsInUse {
                    for (_, agent) in placements {
                        agent.onAdFailedToLoad(message, delay)
                    }
                    self?.placementsInUse.removeAll()
                }
            }
        }
    }

    private class BannerAgent: CASBannerAgent {
        let placementId: String
        weak var provider: CASUnityAdsProvider?
        private var banner: UADSBannerView?

        init(placementId: String, provider: CASUnityAdsProvider) {
            self.placementId = placementId
            self.provider = provider
            super.init(true, 3)
        }

        override func getView() -> UIView? {
            return banner
        }

        override var versionInfo: String {
            return UnityAds.getVersion()
        }

        override func requestAd() throws {
            if isAdReady() {
                onAdLoaded()
                return
            }

            if provider?.initializeUnityAds(self) == false {
                return
            }

            CASHandler.main {
                self.requestAdMainThread()
            }

            try super.requestAd()
        }

        private func requestAdMainThread() {
            if let view = banner, size == loadedSize {
                view.load()
            } else {
                disposeAd()
                loadedSize = size // After Dispose only

                let newView = UADSBannerView(placementId: placementId, size: loadedSize.toCGSize())
                banner = newView
                newView.delegate = self
                newView.load()
            }
        }

        override func disposeAd() {
            super.disposeAd()
            banner?.delegate = nil
            banner = nil
        }
    }

    extension BannerAgent: UADSBannerViewDelegate {
        func bannerViewDidLoad(_ bannerView: UADSBannerView!) {
            onAdLoaded()
        }

        func bannerViewDidClick(_ bannerView: UADSBannerView!) {
            onAdClicked()
        }

        func bannerViewDidError(_ bannerView: UADSBannerView!, error: UADSBannerError!) {
            if error.code == UADSBannerErrorCode.noFillError.rawValue {
                onAdFailedToLoad("No Fill")
            } else {
                onAdFailedToLoad(error.localizedDescription)
            }
        }
    }

    private class InterstitialAgent: CASAgent {
        let placementId: String
        weak var provider: CASUnityAdsProvider?

        init(placementId: String, provider: CASUnityAdsProvider) {
            self.placementId = placementId
            self.provider = provider
            super.init()
        }

        override var versionInfo: String {
            return UnityAds.getVersion()
        }

        override func requestAd() throws {
            guard let provider = provider else {
                onAdFailedToLoad("Provider lost link")
                return
            }
            provider.loadInterstitialAd(agent: self)
        }

        override func isAdReady() -> Bool {
            return UnityAds.isReady(placementId)
        }

        override func showAd(_ controller: UIViewController) throws {
            guard let provider = provider else {
                throw CASError.nilOptional("Provider")
            }
            provider.adShowingAgent = self
            UnityAds.show(controller, placementId: placementId)
        }
    }
#endif
