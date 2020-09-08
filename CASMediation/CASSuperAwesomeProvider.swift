//
//  SuperAwesome.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#if canImport(SuperAwesome)
    import CleverAdsSolutions
    import Foundation
    import SuperAwesome

    final class CASSuperAwesomeProvider: NSObject, CASProvider {
        private var interstitialAgents = [Int: InterstitialAgent]()
        private var rewardedAgents = [Int: InterstitialAgent]()

        func getVersionAndVerify() throws -> String {
            if NSClassFromString("SAVersion") == nil {
                throw CASError.notImplemented
            }
            return SAVersion.getSdkVersion()
        }

        func getRequiredVersion() throws -> String {
            return ""
        }

        func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
            info.setLoadingModeDefault(CASMediationLoadMode.Default)
        }

        func isEarlyInit() -> Bool {
            return false
        }

        func initMain(for wrapper: CASMediationWrapper) throws {
            AwesomeAds.initSDK(wrapper.settings.isDebugMode())
            VideoAd.setCallback { [weak self] placement, event in
                self?.onEvent(placement, event)
            }
            SAInterstitialAd.setCallback { [weak self] placement, event in
                self?.onEvent(placement, event)
            }

            wrapper.onInitializeDelayed()
        }

        func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
            return BannerAgent(
                try info.readInt(forKey: "banner_Id", 30471, 0),
                try info.readInt(forKey: "banner_tablet", 30475, 0),
                try info.readInt(forKey: "banner_mpu", 30472, 0),
                info.isDemo)
        }

        func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
            return try createInterAgent(
                zone: try info.readInt(forKey: "inter_Id", 30473, nil),
                isVideo: try info.readInt(forKey: "isInterVideo", 0, 0) > 0,
                handleRewarded: false,
                isDemo: info.isDemo
            )
        }

        func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
            return try createInterAgent(
                zone: try info.readInt(forKey: "reward_Id", 30479, nil),
                isVideo: true,
                handleRewarded: true,
                isDemo: info.isDemo
            )
        }

        private func createInterAgent(zone: Int, isVideo: Bool, handleRewarded: Bool, isDemo: Bool
        ) throws -> InterstitialAgent {
            let agent = InterstitialAgent(zone, isVideo, handleRewarded)
            if handleRewarded {
                if rewardedAgents[zone] != nil {
                    throw CASError.alreadyExist(id: String(zone))
                }
                rewardedAgents[zone] = agent
            } else {
                if interstitialAgents[zone] != nil {
                    throw CASError.alreadyExist(id: String(zone))
                }
                interstitialAgents[zone] = agent
            }
            if isDemo {
                if isVideo {
                    VideoAd.enableTestMode()
                } else {
                    SAInterstitialAd.enableTestMode()
                }
            }
            return agent
        }

        private func onEvent(_ placement: Int, _ event: SAEvent?) {
            interstitialAgents[placement]?.onEvent(event)
            rewardedAgents[placement]?.onEvent(event)
        }
    }

    private class BannerAgent: CASBannerAgent {
        private let zone: Int
        private let leaderboard: Int
        private let mrec: Int
        private let demo: Bool
        private var view: SABannerAd?
        private var needInit = false

        init(_ zone: Int, _ leaderboard: Int, _ mrec: Int, _ demo: Bool) {
            self.zone = zone
            self.leaderboard = leaderboard
            self.mrec = mrec
            self.demo = demo
            super.init(true, 3)
        }

        override func getView() -> UIView? {
            return view
        }

        override var versionInfo: String {
            return SAVersion.getSdkVersion()
        }

        override func requestAd() throws {
            if !validateSize() {
                return
            }

            if isAdReady() {
                onAdLoaded()
                return
            }

            let targetZone = getSASize()
            if targetZone < 1 {
                onAdWrongSize()
                return
            }

            CASHandler.main { [weak self] in
                self?.needInit = true
                if let view = self?.view {
                    // view.resize(CGRect(origin: CGPoint.zero, size: loadedSize.toCGSize()))
                    view.load(targetZone)
                } else {
                    self?.createBanner().load(targetZone)
                }
            }
            try super.requestAd()
        }

        private func getSASize() -> Int {
            switch loadedSizeIndex {
            case 1: return leaderboard
            case 2: return mrec
            default: return zone
            }
        }

        private func createBanner() -> SABannerAd {
            let newView = SABannerAd(frame: CGRect(origin: CGPoint.zero, size: loadedSize.toCGSize()))
            if demo {
                newView.setTestMode(true)
            }
            newView.setColorTransparent()
            newView.setCallback { [weak self] placement, event in
                self?.onEvent(placement, event)
            }
            view = newView
            return newView
        }

        private func onEvent(_ placement: Int, _ event: SAEvent) {
            switch event {
            case .adLoaded, .adAlreadyLoaded: onAdLoaded()
            case .adEmpty: onAdFailedToLoad("No Fill")
            case .adFailedToLoad: onAdFailedToLoad("Load failed")
            case .adFailedToShow: showFailed("Internal")
            case .adClicked: onAdClicked()
            default: break
            }
        }

        override func isAdReady() -> Bool {
            return super.isAdReady() && view?.hasAdAvailable() == true
        }

        override func showAd(_ controller: UIViewController) throws {
            if needInit {
                needInit = false
                view?.play()
            }
            try super.showAd(controller)
        }

        override func disposeAd() {
            super.disposeAd()
            view?.close()
            view = nil
        }
    }

    private class InterstitialAgent: CASAgent {
        private let zone: Int
        private let isVideo: Bool
        private let handleRewarded: Bool
        private var active: Bool = false

        init(_ zone: Int, _ isVideo: Bool, _ handleRewarded: Bool) {
            self.zone = zone
            self.isVideo = isVideo
            self.handleRewarded = handleRewarded
            super.init()
        }

        override var versionInfo: String {
            return SAVersion.getSdkVersion()
        }

        override func requestAd() throws {
            if isAdReady() {
                onAdLoaded()
                return
            }

            CASHandler.main {
                if self.isVideo {
                    VideoAd.load(withPlacementId: self.zone)
                } else {
                    SAInterstitialAd.load(self.zone)
                }
            }
        }

        override func isAdReady() -> Bool {
            if isVideo {
                return VideoAd.hasAdAvailable(placementId: zone)
            }
            return SAInterstitialAd.hasAdAvailable(zone)
        }

        override func showAd(_ controller: UIViewController) throws {
            active = true

            if isVideo {
                VideoAd.setCloseButton(!handleRewarded)
                VideoAd.play(withPlacementId: zone, fromVc: controller)
            } else {
                SAInterstitialAd.play(zone, fromVC: controller)
            }
        }

        func onEvent(_ saEvent: SAEvent?) {
            switch saEvent {
            case .adLoaded, .adAlreadyLoaded:
                onAdLoaded()
            // VideoAd.getAd(placementId: zone)?.creative.cpm
            case .adEmpty: onAdFailedToLoad("No Fill")
            case .adFailedToLoad: onAdFailedToLoad("Load failed")
            case .adShown: if active { onAdShown() }
            case .adClicked: if active { onAdClicked() }
            case .adEnded: if active && handleRewarded { onAdCompleted() }
            case .adFailedToShow: if active {
                active = false
                showFailed("Internal", -1)
            }
            case .adClosed: if active {
                active = false
                onAdClosed()
            }
            default: break
            }
        }
    }
#endif
