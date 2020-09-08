//
//  ChartboostProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CASChartboost
import CleverAdsSolutions
import Foundation
import UIKit

final class CASChartboostProvider: CASProvider {
    private weak var listener: CASMediationWrapper?
    private var appSignature: String = ""

    func getVersionAndVerify() throws -> String {
        return Chartboost.getSDKVersion()
    }

    func getRequiredVersion() throws -> String {
        return ""
    }

    func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
        if wrapper.appID.isEmpty || appSignature.isEmpty {
            wrapper.setAppID(try info.readString(
                forKey: "AppID",
                "5ee23ef0016a4e09be60bf77", // Chartboost sample app
                ""
                // or use from eschenkoden.job qwer
            ))
            // TODO: migrate Signature storage like AppID
            appSignature = try info.readString(
                forKey: "AppSignature",
                "4db5be4bdcfa503054e970987ab036a9e8730bdb", // Chartboost sample app
                ""
            )
        }
    }

    func isEarlyInit() -> Bool {
        return true
    }

    func initMain(for wrapper: CASMediationWrapper) throws {
        guard #available(iOS 9.0, *) else {
            wrapper.onInitialized(success: false, "Not supported below 9.0")
            return
        }
        listener = wrapper

        if wrapper.appID.isEmpty || appSignature.isEmpty {
            wrapper.onInitialized(success: false, "App ID not found")
            return
        }

        wrapper.settings.appendOptionChanged(delegate: self)

        let gdpr = wrapper.settings.getUserConsent()
        if gdpr != .undefined {
            onChangedState(gdpr: gdpr)
        }
        let ccpa = wrapper.settings.getDoNotSell()
        if ccpa != .undefined {
            onChangedState(ccpa: ccpa)
        }

        onChangedDebugMode(wrapper.settings.isDebugMode())
        onChangedMuteAdSounds(wrapper.settings.isMutedAdSounds())

        // Before start
        if let name = wrapper.settings.getPluginPlatformName() {
            if let version = wrapper.settings.getPluginPlatformVersion() {
                if name == "Unity" {
                    Chartboost.setFramework(.unity, withVersion: version)
                }
            }
        }

        Chartboost.start(withAppId: wrapper.appID, appSignature: appSignature) { success in
            wrapper.onInitialized(success: success, "")
        }
    }

    func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
        return BannerAgent(location:
            try info.readString(forKey: "BannerLoc", CBLocationDefault, CBLocationDefault))
    }

    func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
        return InterstitialAgent(location:
            try info.readString(forKey: "InterLoc", CBLocationDefault, CBLocationDefault))
    }

    func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
        return RewardedAgent(location:
            try info.readString(forKey: "RewardedLoc", CBLocationDefault, CBLocationDefault))
    }
}

extension CASChartboostProvider: CASOptionsListener {
    func onChangedState(gdpr: CASConsentStatus) {
        if gdpr == .undefined {
            Chartboost.clearDataUseConsent(for: .GDPR)
        } else {
            Chartboost.addDataUseConsent(.GDPR(gdpr == .accepted ? .behavioral : .nonBehavioral))
        }
    }

    func onChangedState(ccpa: CASCCPAStatus) {
        if ccpa == .undefined {
            Chartboost.clearDataUseConsent(for: .CCPA)
        } else {
            Chartboost.addDataUseConsent(.CCPA(ccpa == .optInSale ? .optInSale : .optOutSale))
        }
    }

    func onChangedTagged(audience: CASAudience) {
    }

    func onChangedDebugMode(_ debug: Bool) {
        // Not supported for version 8.2.1
        //Chartboost.setLoggingLevel(debug ? .verbose : .off)
    }

    func onChangedMuteAdSounds(_ muted: Bool) {
        Chartboost.setMuted(muted)
    }
}

private class AdDelegate: NSObject, CHBBannerDelegate, CHBInterstitialDelegate, CHBRewardedDelegate {
    weak var agent: CASAgent?
    var view: CHBAd?

    func didCacheAd(_ event: CHBCacheEvent, error: CHBCacheError?) {
        guard let agent = agent else {
            Debug.logWarning("Chartboost delegate lost agent: didCacheAd")
            view?.delegate = nil
            view = nil
            return
        }
        if let error = error {
            view = nil
            switch error.code {
            case .noAdFound: agent.onAdFailedToLoad("No Fill")
            case .publisherDisabled: agent.onAdFailedToLoad("Disabled", 300.0)
            case .internetUnavailable: agent.onAdFailedToLoad("No net", 5.0)
            default: agent.onAdFailedToLoad(error.description)
            }
        } else {
            agent.onAdLoaded()
        }
    }

    func willShowAd(_ event: CHBShowEvent) {
        guard let agent = agent else {
            Debug.logWarning("Chartboost delegate lost agent: willShowAd")
            view?.delegate = nil
            view = nil
            return
        }
        agent.onAdShown()
    }

    func didShowAd(_ event: CHBShowEvent, error: CHBShowError?) {
        guard let agent = agent else {
            Debug.logWarning("Chartboost delegate lost agent: didShowAd")
            view?.delegate = nil
            view = nil
            return
        }
        if let error = error {
            if agent.adType == CASType.banner {
                agent.warning("Ad was shown with error: \(error.description)")
            } else {
                agent.showFailed(error.description)
            }
        }
    }

    func didClickAd(_ event: CHBClickEvent, error: CHBClickError?) {
        if let error = error {
            agent?.warning("Ad was clicked with error: \(error.description)")
        } else {
            agent?.onAdClicked()
        }
    }

    func didFinishHandlingClick(_ event: CHBClickEvent, error: CHBClickError?) {
        if let error = error {
            agent?.warning("Ad was finish clicked with error: \(error.description)")
        }
    }

    func didDismissAd(_ event: CHBDismissEvent) {
        guard let agent = agent else {
            Debug.logWarning("Chartboost delegate lost agent: didDismissAd")
            view?.delegate = nil
            view = nil
            return
        }
        if let error = event.error {
            agent.warning("Ad Closed with error: \(error)")
        }
        view = nil
        agent.onAdWillClose()
        agent.onAdClosed()
    }

    func didEarnReward(_ event: CHBRewardEvent) {
        guard let agent = agent else {
            Debug.logWarning("Chartboost delegate lost agent: didEarnReward")
            view?.delegate = nil
            view = nil
            return
        }
        agent.onAdCompleted()
    }
}

private class BannerAgent: CASBannerAgent {
    private let location: String
    private let delegate: AdDelegate
    private var banner: CHBBanner?
    private var needShow = false

    init(location: String) {
        self.location = location
        delegate = AdDelegate()
        super.init(true, 3)
        delegate.agent = self
    }

    override func getView() -> UIView? {
        return banner
    }

    override var versionInfo: String {
        return Chartboost.getSDKVersion()
    }

    override func requestAd() throws {
        if loadedSize != size {
            disposeAd()
            loadedSize = size
        }

        if isAdReady() {
            onAdLoaded()
            return
        }

        if let banner = banner {
            delegate.view = banner
            banner.cache()
        } else {
            CASHandler.main {
                self.createBanner()
            }
        }
        try super.requestAd()
    }

    private func createBanner() {
//        let mediation = CHBMediation(type: .other,
//                                     libraryVersion: Chartboost.getSDKVersion(),
//                                     adapterVersion: CAS.getSDKVersion())

        let newView = CHBBanner(size: loadedSize.toCGSize(),
                                location: location,
                                delegate: delegate)

        delegate.view = newView
        newView.automaticallyRefreshesContent = false
        newView.cache()
    }

    override func onAdLoaded() {
        needShow = true
        super.onAdLoaded()
    }

    override func showAd(_ controller: UIViewController) throws {
        guard let banner = banner else {
            throw CASError.nilOptional("Banner")
        }
        if needShow {
            needShow = false
            banner.show(from: controller)
        }
        delegate.view = banner
        try showAd(controller)
    }

    override func onRefreshed() -> Float {
        return 10.0
    }

    override func disposeAd() {
        super.disposeAd()
        banner = nil
        delegate.view = nil
    }
}

private class InterstitialAgent: CASAgent {
    let location: String
    let delegate: AdDelegate

    init(location: String) {
        self.location = location
        delegate = AdDelegate()
        super.init()
        delegate.agent = self
    }

    override var versionInfo: String {
        return Chartboost.getSDKVersion()
    }

    override func requestAd() throws {
        if isAdReady() {
            onAdLoaded()
            return
        }

//        CHBMediation(type: .other,
//                    libraryVersion: Chartboost.getSDKVersion(),
//                    adapterVersion: CAS.getSDKVersion())

        let newInter = createView()
        delegate.view = newInter
        newInter.cache()
    }

    func createView() -> CHBAd {
        return CHBInterstitial(location: location, delegate: delegate)
    }

    override func isAdReady() -> Bool {
        return delegate.view?.isCached == true
    }

    override func showAd(_ controller: UIViewController) throws {
        guard let inter = delegate.view else {
            throw CASError.nilOptional("View")
        }
        delegate.view = inter
        inter.show(from: controller)
    }
}

private class RewardedAgent: InterstitialAgent {
    override func createView() -> CHBAd {
        return CHBRewarded(location: location, delegate: delegate)
    }
}
