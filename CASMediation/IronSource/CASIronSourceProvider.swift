//
//  IronSourceProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CASIronSource
import CleverAdsSolutions
import Foundation
import UIKit

final class CASIronSourceProvider: NSObject, CASProvider {
    private weak var wrapper: CASMediationWrapper?
    private var interAgents = [String: InterstitialAgent]()
    private var rewardAgents = [String: RewardedAgent]()

    func getVersionAndVerify() throws -> String {
        if NSClassFromString("IronSource") == nil {
            throw CASError.notImplemented
        }
        return IronSource.sdkVersion()
    }

    func getRequiredVersion() throws -> String {
        return ""
    }

    func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
        info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)
        if wrapper.appID.isEmpty {
            wrapper.setAppID(try info.readString(forKey: "appId", "85460dcd", ""))
            // TODO: Set valid demo app
            // "b4c9de3d") // DemoApp eschenkoden.job@gmail.com
            // IS demo app 85460dcd
        }
    }

    func isEarlyInit() -> Bool {
        return false
    }

    func initMain(for wrapper: CASMediationWrapper) throws {
        self.wrapper = wrapper
        if wrapper.appID.isEmpty {
            wrapper.onInitialized(success: false, "Empty App ID")
            return
        }

//        do {
//            let userID = IronSource.getAdvertiserId(activity)
//            if (userID.isNullOrEmpty())
//                IronSource.setUserId("userId")
//            else
//                IronSource.setUserId(userID)
//        } catch  {
//            wrapper.warning("Error on get Advertiser ID: ${e.localizedMessage}")
//        }

        // Set listeners before init
        IronSource.setISDemandOnlyInterstitialDelegate(self)
        IronSource.setISDemandOnlyRewardedVideoDelegate(self)

        onChangedDebugMode(wrapper.settings.isDebugMode())
        let ccpa = wrapper.settings.getDoNotSell()
        if ccpa != .undefined {
            onChangedState(ccpa: ccpa) // Before Init
        }
        let gdpr = wrapper.settings.getUserConsent()
        if gdpr != .undefined {
            onChangedState(gdpr: gdpr) // Before Init
        }

        wrapper.settings.appendOptionChanged(delegate: self)
        IronSource.initISDemandOnly(wrapper.appID, adUnits: [IS_INTERSTITIAL, IS_REWARDED_VIDEO])
        wrapper.onInitializeDelayed()
    }

    func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
        throw CASError.notImplemented
    }

    func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
        let id = try info.readString(forKey: "inter_Id", "0", nil)
        if interAgents[id] != nil {
            throw CASError.alreadyExist(id: id)
        }
        let agent = InterstitialAgent(instanceID: id)
        interAgents[id] = agent
        return agent
    }

    func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
        let id = try info.readString(forKey: "reward_Id", "0", nil)
        if rewardAgents[id] != nil {
            throw CASError.alreadyExist(id: id)
        }
        let agent = RewardedAgent(instanceID: id)
        rewardAgents[id] = agent
        return agent
    }
}

extension CASIronSourceProvider: CASOptionsListener, ISLogDelegate {
    func onChangedState(gdpr: CASConsentStatus) {
        IronSource.setConsent(gdpr == .accepted)
    }

    func onChangedState(ccpa: CASCCPAStatus) {
        IronSource.setMetaDataWithKey("do_not_sell", value: ccpa == .optInSale ? "NO" : "YES")
    }

    func onChangedTagged(audience: CASAudience) {
    }

    func onChangedDebugMode(_ debug: Bool) {
        IronSource.setAdaptersDebug(debug)
        
//        if debug {
        // Duplicate console log
//            IronSource.setLogDelegate(self)
//            ISIntegrationHelper.validateIntegration()
//        }
    }

    func onChangedMuteAdSounds(_ muted: Bool) {
    }

    func sendLog(_ log: String!, level: ISLogLevel, tag: LogTag) {
        if let log = log {
            wrapper?.log(log)
        }
    }
}

extension CASIronSourceProvider: ISDemandOnlyInterstitialDelegate {
    func interstitialDidLoad(_ instanceId: String!) {
        interAgents[instanceId]?.onAdLoaded()
    }

    func interstitialDidFailToLoadWithError(_ error: Error!, instanceId: String!) {
        if let agent = interAgents[instanceId] {
            let nsError = error as NSError
            if nsError.code == 509 {
                agent.onAdFailedToLoad("No Fill")
            } else {
                agent.onAdFailedToLoad("\(nsError.localizedDescription) Code: \(nsError.code)")
            }
        }
    }

    func interstitialDidOpen(_ instanceId: String!) {
        interAgents[instanceId]?.onAdShown()
    }

    func interstitialDidClose(_ instanceId: String!) {
        if let agent = interAgents[instanceId] {
            agent.onAdWillClose()
            agent.onAdClosed()
        }
    }

    func interstitialDidFailToShowWithError(_ error: Error!, instanceId: String!) {
        let nsError = error as NSError
        interAgents[instanceId]?.showFailed("\(nsError.localizedDescription) Code: \(nsError.code)")
    }

    func didClickInterstitial(_ instanceId: String!) {
        interAgents[instanceId]?.onAdClicked()
    }
}

extension CASIronSourceProvider: ISDemandOnlyRewardedVideoDelegate {
    func rewardedVideoDidLoad(_ instanceId: String!) {
        rewardAgents[instanceId]?.onAdLoaded()
    }

    func rewardedVideoDidFailToLoadWithError(_ error: Error!, instanceId: String!) {
        if let agent = rewardAgents[instanceId] {
            let nsError = error as NSError
            if nsError.code == 509 {
                agent.onAdFailedToLoad("No Fill")
            } else {
                agent.onAdFailedToLoad("\(nsError.localizedDescription) Code: \(nsError.code)")
            }
        }
    }

    func rewardedVideoDidOpen(_ instanceId: String!) {
        rewardAgents[instanceId]?.onAdShown()
    }

    func rewardedVideoDidClose(_ instanceId: String!) {
        rewardAgents[instanceId]?.onAdClosed()
    }

    func rewardedVideoDidFailToShowWithError(_ error: Error!, instanceId: String!) {
        let nsError = error as NSError
        rewardAgents[instanceId]?.showFailed("\(nsError.localizedDescription) Code: \(nsError.code)")
    }

    func rewardedVideoDidClick(_ instanceId: String!) {
        rewardAgents[instanceId]?.onAdClicked()
    }

    func rewardedVideoAdRewarded(_ instanceId: String!) {
        rewardAgents[instanceId]?.onAdCompleted()
    }
}

private class InterstitialAgent: CASAgent {
    private let instanceID: String

    init(instanceID: String) {
        self.instanceID = instanceID
        super.init()
    }

    override var versionInfo: String {
        return IronSource.sdkVersion()
    }

    override func requestAd() throws {
        IronSource.loadISDemandOnlyInterstitial(instanceID)
    }

    override func showAd(_ controller: UIViewController) throws {
        IronSource.showISDemandOnlyInterstitial(controller, instanceId: instanceID)
    }

    override func isAdReady() -> Bool {
        return IronSource.hasISDemandOnlyInterstitial(instanceID)
    }
}

private class RewardedAgent: CASAgent {
    private let instanceID: String

    init(instanceID: String) {
        self.instanceID = instanceID
        super.init()
    }

    override var versionInfo: String {
        return IronSource.sdkVersion()
    }

    override func requestAd() throws {
        IronSource.loadISDemandOnlyRewardedVideo(instanceID)
    }

    override func showAd(_ controller: UIViewController) throws {
        IronSource.showISDemandOnlyRewardedVideo(controller, instanceId: instanceID)
    }

    override func isAdReady() -> Bool {
        return IronSource.hasISDemandOnlyRewardedVideo(instanceID)
    }
}
