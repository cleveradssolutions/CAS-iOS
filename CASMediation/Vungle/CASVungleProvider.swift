//
//  VungleProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CASVungle
import CleverAdsSolutions
import Foundation
import UIKit

final class CASVungleProvider: NSObject, CASProvider {
    private weak var listener: CASMediationWrapper?
    private var agents = [String: CASAgent]()

    required override init() {
        super.init()
    }

    func getVersionAndVerify() throws -> String {
        if NSClassFromString("VungleSDK") == nil {
            throw CASError.notImplemented
        }
        return VungleSDKVersion
    }

    func getRequiredVersion() throws -> String {
        return ""
    }

    func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
        info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)
        if wrapper.appID.isEmpty {
            wrapper.setAppID(try info.readString(forKey: "ApplicationID",
                                                 "5ec7fd5468a0950001a9a239", // eschenkoden.job@gmail.com
                                                 "")
            )
        }
    }

    func isEarlyInit() -> Bool {
        return false
    }

    func initMain(for wrapper: CASMediationWrapper) throws {
        listener = wrapper
        if wrapper.appID.isEmpty {
            wrapper.onInitialized(success: false, "App ID Not Found")
            return
        }

        let sdk = VungleSDK.shared()
        sdk.delegate = self
        sdk.disableBannerRefresh()
        if sdk.isInitialized {
            wrapper.onInitialized(success: true, "")
            return
        }
        try sdk.start(withAppId: wrapper.appID)
    }

    func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
        let banner = try info.readString(forKey: "banner_PlacementID", "FIRSTBANNER-0290748", "")
        let mrec = try info.readString(forKey: "banner_MREC", "FIRSTMREC-9064478", "")
        if banner.isEmpty && mrec.isEmpty {
            throw CASError.emptyID
        }
        let agent = BannerAgent(bannerID: banner, mrecID: mrec)
        if !banner.isEmpty {
            try appendAgent(placement: banner, agent)
        }
        if !mrec.isEmpty {
            try appendAgent(placement: mrec, agent)
        }
        return agent
    }

    func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
        let inter = try info.readString(forKey: "inter_PlacementID", "FIRSTINTER-8623490", nil)
        let agent = InterstitialAgent(placement: inter)
        try appendAgent(placement: inter, agent)
        return agent
    }

    func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
        let inter = try info.readString(forKey: "reward_PlacementID", "FIRSTREWARDED-1575791", nil)
        let agent = InterstitialAgent(placement: inter)
        try appendAgent(placement: inter, agent)
        return agent
    }

    private func appendAgent(placement: String, _ agent: CASAgent) throws {
        if agents[placement] == nil {
            agents[placement] = agent
        } else {
            throw CASError.alreadyExist(id: placement)
        }
    }
}

extension CASVungleProvider: CASOptionsListener {
    func onChangedState(gdpr: CASConsentStatus) {
        VungleSDK.shared().update(gdpr == .accepted ? .accepted : .denied, consentMessageVersion: "1.0")
    }

    func onChangedState(ccpa: CASCCPAStatus) {
        VungleSDK.shared().update(ccpa == .optInSale ? .accepted : .denied)
    }

    func onChangedTagged(audience: CASAudience) {
        // TODO: check required for COPPA
        // VungleSDK.setPublishIDFV(forChildren ?? false == false)
    }

    func onChangedDebugMode(_ debug: Bool) {
        VungleSDK.shared().setLoggingEnabled(debug)
        if debug {
            VungleSDK.shared().attach(self)
        } else {
            VungleSDK.shared().detach(self)
        }
    }

    func onChangedMuteAdSounds(_ muted: Bool) {
        VungleSDK.shared().muted = muted
    }
}

extension CASVungleProvider: VungleSDKLogger {
    func vungleSDKLog(_ message: String) {
        listener?.log(message)
    }
}

extension CASVungleProvider: VungleSDKDelegate {
    func vungleSDKDidInitialize() {
        // Initialization has succeeded and SDK is ready to load an ad or play one if there
        // is one pre-cached already
        if let it = listener {
            let ccpa = it.settings.getCCPAStatus()
            if ccpa != .undefined {
                onChangedState(ccpa: ccpa)
            }
            let gdpr = it.settings.getUserConsent()
            if gdpr != .undefined {
                onChangedState(gdpr: gdpr)
            }
            it.onInitialized(success: true, "")
        } else {
            Debug.logError("Vungle initialize not found Network Wrapper")
        }
    }

    func vungleSDKFailedToInitializeWithError(_ error: Error) {
        if let it = listener {
            let ccpa = it.settings.getCCPAStatus()
            if ccpa != .undefined {
                onChangedState(ccpa: ccpa)
            }
            let gdpr = it.settings.getUserConsent()
            if gdpr != .undefined {
                onChangedState(gdpr: gdpr)
            }
            it.onInitialized(success: false, error.localizedDescription)
            CASHandler.post(20000) {
                do {
                    try self.initMain(for: it)
                } catch {
                    Debug.logException("Vungle ReInit after Failed", error)
                }
            }
        } else {
            Debug.logError("Vungle initialize not found Network Wrapper")
        }
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        if let placementID = placementID {
            agents[placementID]?.onAdClicked()
        } else {
            listener?.warning("Track Click for NIL placement ID")
        }
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        if let placementID = placementID {
            agents[placementID]?.onAdCompleted()
        } else {
            listener?.warning("Reward User for NIL placement ID")
        }
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        guard let placementID = placementID else {
            listener?.log("Playability Update for NIL placement ID")
            return
        }

        if isAdPlayable {
            if let agent = agents[placementID] {
                if let banner = agent as? BannerAgent {
                    banner.onLoaded(placement: placementID)
                } else {
                    agent.onAdLoaded()
                }
            }
            return
        }

        // Vungle SDK calls this method with isAdPlayable NO just after an ad is presented. These events
        // should be ignored as they aren't related to a load call. Assume an ad is presented if Vungle
        // SDK has an ad cached for this placement.
        if VungleSDK.shared().isAdCached(forPlacementID: placementID) {
            return
        }

        // Ad not playable. Return an error.

        if let agent = agents[placementID] {
            let message: String
            if let nsError = error as NSError? {
                message = "\(nsError.localizedDescription) Code: \(nsError.code)"
            } else {
                message = "No Fill"
            }
            if let banner = agent as? BannerAgent {
                banner.onFailedToLoad(placement: placementID, message)
            } else {
                agent.onAdFailedToLoad(message)
            }
        }
    }

    func vungleWillShowAd(forPlacementID placementID: String?) {
        if let placementID = placementID {
            agents[placementID]?.onAdShown()
        } else {
            listener?.warning("Did Show Ad for NIL placement ID")
        }
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        agents[placementID]?.onAdWillClose()
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        agents[placementID]?.onAdClosed()
    }
}

private class BannerAgent: CASBannerAgent {
    private let bannerID: String
    private let mrecID: String

    private var container: UIView?
    private var attachedPlacement: String?

    override var versionInfo: String {
        return VungleSDKVersion
    }

    override func getView() -> UIView? {
        return container
    }

    init(bannerID: String, mrecID: String) {
        self.bannerID = bannerID
        self.mrecID = mrecID
        super.init(true, 3)
    }

    private var isNativeActive: Bool {
        return loadedSizeIndex == 3
    }

    override func requestAd() throws {
        if loadedSize != size || loadedSizeIndex < 0 {
            let validSize = findClosestSize([
                CGSize(width: 300, height: 50),
                CGSize(width: 320, height: 50),
                CGSize(width: 728, height: 90),
                CGSize(width: 300, height: 250), // Native only
            ])

            if validSize < 0 {
                return
            }
        }

        if isAdReady() {
            onAdLoaded()
            return
        }

        disposeAd()
        do {
            try preCache()
        } catch let error as NSError {
            if error.code == VungleSDKErrorSleepingPlacement.rawValue {
                onAdFailedToLoad("Sleeping", 360.0)
            } else {
                onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)", 180.0)
            }
            return
        }
        try super.requestAd()
    }

    private func getVungleSize() -> VungleAdSize {
        switch loadedSizeIndex {
        case 0: return VungleAdSize.bannerShort
        case 1: return VungleAdSize.banner
        case 2: return VungleAdSize.bannerLeaderboard
        case 3: return VungleAdSize.unknown
        default: return VungleAdSize.bannerShort
        }
    }

    private func preCache() throws {
        let sdk = VungleSDK.shared()
        if isNativeActive {
            if mrecID.isEmpty {
                onAdFailedToLoad("Undefined zone for size")
                return
            }
            if sdk.isAdCached(forPlacementID: mrecID) {
                CASHandler.main {
                    self.onAdLoaded()
                }
                return
            }
            try VungleSDK.shared().loadPlacement(withID: mrecID)
        } else {
            if bannerID.isEmpty {
                onAdFailedToLoad("Undefined zone for size")
                return
            }
            let vunSize = getVungleSize()
            if sdk.isAdCached(forPlacementID: bannerID, with: vunSize) {
                CASHandler.main {
                    self.onAdLoaded()
                }
                return
            }
            try VungleSDK.shared().loadPlacement(withID: bannerID, with: vunSize)
        }
    }

    func onLoaded(placement: String) {
        if isAdCached() {
            // Already invoked an ad load callback.
            log("On loaded placement: \(placement) but ad is ready cached")
            return
        }

        if placement == bannerID {
            if isNativeActive {
                log("On loaded Banner placement: \(placement) but waiting MREC placement")
                return
            }
        } else if placement == mrecID {
            if !isNativeActive {
                log("On loaded MREC placement: \(placement) but waiting Banner placement")
                return
            }
        } else {
            warning("On loaded wrong placement: \(placement)")
            return
        }

        onAdLoaded()
    }

    override func onAdLoaded() {
        let container: UIView
        if let target = self.container {
            container = target
        } else {
            container = UIView(frame: CGRect(origin: CGPoint.zero, size: loadedSize.toCGSize()))
            if #available(iOS 11.0, *) {
                container.insetsLayoutMarginsFromSafeArea = false
            }
            self.container = container
        }

        do {
            let placement = isNativeActive ? mrecID : bannerID
            try VungleSDK.shared().addAdView(to: container, withOptions: nil, placementID: placement)
            attachedPlacement = placement
            super.onAdLoaded()
        } catch let error as NSError {
            onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)")
        }
    }

    func onFailedToLoad(placement: String, _ message: String) {
        if isAdCached() {
            // Already invoked an ad load callback.
            log("On failed to load placement: \(placement) but ad is ready cached")
            return
        }
        if placement == bannerID {
            if isNativeActive {
                log("On failed to load Banner placement: \(placement) but waiting MREC placement")
                return
            }
        } else if placement == mrecID {
            if !isNativeActive {
                log("On failed to load MREC placement: \(placement) but waiting Banner placement")
                return
            }
        } else {
            warning("On failed to load wrong placement: \(placement)")
            return
        }
        onAdFailedToLoad(message)
    }

    override func disposeAd() {
        super.disposeAd()
        if let placement = attachedPlacement {
            destroyMainThread(target: placement)
            attachedPlacement = nil
        }
    }

    override func onDestroyMainThread(_ target: Any) {
        super.onDestroyMainThread(target)
        if let placement = target as? String {
            VungleSDK.shared().finishDisplayingAd(placement)
        }
    }
}

private class InterstitialAgent: CASAgent {
    private let placement: String

    override var versionInfo: String {
        return VungleSDKVersion
    }

    init(placement: String) {
        self.placement = placement
        super.init()
    }

    override func isAdReady() -> Bool {
        return checkAdReadyMainThread()
    }

    override func isAdReadyMainThread() -> Bool {
        return VungleSDK.shared().isAdCached(forPlacementID: placement)
    }

    override func requestAd() throws {
        do {
            try VungleSDK.shared().loadPlacement(withID: placement)
        } catch let error as NSError {
            if error.code == VungleSDKErrorSleepingPlacement.rawValue {
                onAdFailedToLoad("Sleeping", 360.0)
            } else {
                onAdFailedToLoad("\(error.localizedDescription) Code: \(error.code)", 180.0)
            }
            return
        }
    }

    override func showAd(_ controller: UIViewController) throws {
        let targetOrientation: UInt
        if UIApplication.shared.statusBarOrientation.isLandscape {
            targetOrientation = UIInterfaceOrientationMask.landscape.rawValue
        } else {
            targetOrientation = UIInterfaceOrientationMask.portrait.rawValue
        }

        try VungleSDK.shared()
            .playAd(controller,
                    options: [VunglePlayAdOptionKeyOrientations: targetOrientation],
                    placementID: placement)
    }

    override func onAdLoaded() {
        if isAdCached() {
            // Already invoked an ad load callback.
            log("On loaded placement: \(placement) but ad is ready cached")
            return
        }
        super.onAdLoaded()
    }

    override func onAdFailedToLoad(_ message: String?, _ delay: Float = -1.0) {
        if isAdCached() {
            // Already invoked an ad load callback.
            log("On failed to load placement: \(placement) but ad is ready cached")
            return
        }
        super.onAdFailedToLoad(message, delay)
    }
}
