//
//  KidozProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import Foundation
import CASKidoz
import UIKit
import CleverAdsSolutions

private let kidozSDK = CASKidozBridge.sharedSDK()

final class CASKidozProvider: NSObject, CASProvider {
    private var appToken = ""
    private weak var listener: CASMediationWrapper?
    
    func getVersionAndVerify() throws -> String {
        return kidozSDK.getVersion()
    }

    func getRequiredVersion() throws -> String {
        return ""
    }

    func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
        if wrapper.appID.isEmpty || appToken.isEmpty {
            wrapper.setAppID(try info.readString(forKey: "AppID", "8", ""))
            appToken = try info.readString(forKey: "Token", "QVBIh5K3tr1AxO4A1d4ZWx1YAe5567os", "")
        }
    }

    func isEarlyInit() -> Bool {
        return false
    }

    func initMain(for wrapper: CASMediationWrapper) throws {
        listener = wrapper
        if wrapper.appID.isEmpty || appToken.isEmpty {
            wrapper.onInitialized(success: false, "App ID or Token Not Found")
            return
        }
        kidozSDK.initialize(withPublisherID: wrapper.appID,
                                           securityToken: appToken,
                                           with: self)
    }

    func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
        return CASHandler.awaitMain(30, {
            BannerAgent()
        })
    }

    func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
        return InterstitialAgent()
    }

    func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
        return RewardedAgent()
    }
}

extension CASKidozProvider: KDZInitDelegate {
    func onInitSuccess() {
        listener?.onInitialized(success: true, "")
    }

    func onInitError(_ error: String!) {
        listener?.onInitialized(success: false, error)
    }
}

private class BannerAgent: CASBannerAgent {
    private var banner: UIView?
    private var isWaitResponse = false

    init() {
        super.init(false, 3)
    }

    override func getView() -> UIView? {
        return banner
    }

    override var versionInfo: String {
        return kidozSDK.getVersion()
    }

    override func requestAd() throws {
        let size = self.size
        if size.width < 320 || size.height < 50 {
            onAdWrongSize()
            return
        }

        loadedSize = size
        isWaitResponse = true
        if banner == nil || !kidozSDK.isBannerInitialized() {
            CASHandler.main {
                self.initInstance()
            }
        } else if kidozSDK.isBannerReady() {
            onAdLoaded()
            return
        } else {
            kidozSDK.loadBanner()
        }
        try super.requestAd()
    }

    private func initInstance() {
        let banner = UIView(frame: CGRect(origin: CGPoint.zero, size: CASSize.banner.toCGSize()))
        self.banner = banner
        kidozSDK.initializeBanner(with: self, with: banner)
    }

    override func showAd(_ controller: UIViewController) throws {
        try super.showAd(controller)
        kidozSDK.showBanner()
    }

    override func hideAd() {
        kidozSDK.hideBanner()
        super.hideAd()
    }

    override func onRefreshed() -> Float {
        disposeAd()
        return super.onRefreshed()
    }
}

extension BannerAgent: KDZBannerDelegate {
    func bannerDidInitialize() {
        log("Instance Initialized")
        if isWaitResponse {
            kidozSDK.loadBanner()
        }
    }

    func bannerDidClose() {
        onAdFailedToLoad("Internal closed", 0)
    }

    func bannerDidOpen() {
    }

    func bannerIsReady() {
        onAdLoaded()
    }

    func bannerReturnedWithNoOffers() {
        log("ReturnedWithNoOffers")
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("No Fill")
        }
    }

    func bannerLoadFailed() {
        log("LoadFailed")
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("Unknown error")
        }
    }

    func bannerDidReciveError(_ errorMessage: String!) {
        onAdFailedToLoad(errorMessage)
    }

    func bannerLeftApplication() {
        onAdClicked()
    }
}

private class InterstitialAgent: CASAgent {
    private var isWaitResponse = false

    override var versionInfo: String {
        return kidozSDK.getVersion()
    }

    override func requestAd() throws {
        if isAdReady() {
            onAdLoaded()
            return
        }
        isWaitResponse = true
        if !kidozSDK.isInterstitialInitialized() {
            CASHandler.main {
                kidozSDK.initializeInterstitial(with: self)
            }
        } else {
            kidozSDK.loadInterstitial()
        }
    }

    override func isAdReady() -> Bool {
        return kidozSDK.isInterstitialReady()
    }

    override func showAd(_ controller: UIViewController) throws {
        kidozSDK.showInterstitial()
    }
}

extension InterstitialAgent: KDZInterstitialDelegate {
    func interstitialDidInitialize() {
        log("Instance Initialized")
        if isWaitResponse {
            kidozSDK.loadInterstitial()
        }
    }

    func interstitialDidClose() {
        onAdWillClose()
        onAdClosed()
    }

    func interstitialDidOpen() {
        onAdShown()
    }

    func interstitialIsReady() {
        onAdLoaded()
    }

    func interstitialReturnedWithNoOffers() {
        log("ReturnedWithNoOffers")
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("No Fill")
        }
    }

    func interstitialDidPause() {
    }

    func interstitialDidResume() {
    }

    func interstitialLoadFailed() {
        log("LoadFailed")
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("Unknown error")
        }
    }

    func interstitialDidReciveError(_ errorMessage: String!) {
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad(errorMessage)
        } else {
            showFailed(errorMessage)
        }
    }

    func interstitialLeftApplication() {
        onAdClicked()
    }
}

private class RewardedAgent: CASAgent {
    private var isWaitResponse = false

    override var versionInfo: String {
        return kidozSDK.getVersion()
    }

    override func requestAd() throws {
        if isAdReady() {
            onAdLoaded()
            return
        }
        isWaitResponse = true
        if !kidozSDK.isRewardedInitialized() {
            CASHandler.main {
                kidozSDK.initializeRewarded(with: self)
            }
        } else {
            kidozSDK.loadRewarded()
        }
    }

    override func isAdReady() -> Bool {
        return kidozSDK.isRewardedReady()
    }

    override func showAd(_ controller: UIViewController) throws {
        kidozSDK.showRewarded()
    }
}

extension RewardedAgent: KDZRewardedDelegate {
    func rewardedDidInitialize() {
        log("Instance Initialized")
        if isWaitResponse {
            kidozSDK.loadRewarded()
        }
    }

    func rewardedDidClose() {
        onAdWillClose()
        onAdClosed()
    }

    func rewardedDidOpen() {
        onAdShown()
    }

    func rewardedIsReady() {
        onAdLoaded()
    }

    func rewardedReturnedWithNoOffers() {
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("No Fill")
        }
    }

    func rewardedDidPause() {
    }

    func rewardedDidResume() {
    }

    func rewardedLoadFailed() {
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad("Unknown error")
        }
    }

    func rewardedDidReciveError(_ errorMessage: String!) {
        if isWaitResponse {
            isWaitResponse = false
            onAdFailedToLoad(errorMessage)
        } else {
            showFailed(errorMessage)
        }
    }

    func rewardReceived() {
        onAdCompleted()
    }

    func rewardedStarted() {
        log("Rewarded Started")
    }

    func rewardedLeftApplication() {
        onAdClicked()
    }
}
