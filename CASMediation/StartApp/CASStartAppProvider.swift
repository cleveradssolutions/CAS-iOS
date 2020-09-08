//
//  StartAppProvider.swift
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CASStartApp
import CleverAdsSolutions
import Foundation
import UIKit

final class CASStartAppProvider: CASProvider {
    private weak var listener: CASMediationWrapper?

    func getVersionAndVerify() throws -> String {
        if NSClassFromString("STAStartAppSDK") == nil {
            throw CASError.notImplemented
        }
        return "4.5.0" // STAStartAppSDK.sharedInstance().version // wrong init
    }

    func getRequiredVersion() throws -> String {
        return ""
    }

    func prepareSettings(with info: CASMediationInfo, for wrapper: CASMediationWrapper) throws {
        info.setLoadingModeDefault(CASMediationLoadMode.SingleCache)
        if wrapper.appID.isEmpty {
            wrapper.setAppID(try info.readString(forKey: "aplicationID", "ApplicationId", ""))
        }
    }

    func isEarlyInit() -> Bool {
        return false
    }

    func initMain(for wrapper: CASMediationWrapper) throws {
        listener = wrapper
        if wrapper.appID.isEmpty {
            wrapper.onInitialized(success: false, "App id is empty")
            return
        }
        CASHandler.main {
            self.initSTA(wrapper)
        }
    }

    func initSTA(_ wrapper: CASMediationWrapper) {
        guard let sdk = STAStartAppSDK.sharedInstance() else {
            wrapper.onInitialized(success: false, "Cant create SDK")
            return
        }
        sdk.appID = wrapper.appID
        sdk.testAdsEnabled = wrapper.isDemoAdMode
        sdk.consentDialogEnabled = false
        sdk.returnAdEnabled = false

        let gdpr = wrapper.settings.getUserConsent()
        if gdpr != .undefined {
            onChangedState(gdpr: gdpr)
        }

        //        StartAppAd.disableSplash()
        //        StartAppAd.disableAutoInterstitial()

        wrapper.settings.appendOptionChanged(delegate: self)
        wrapper.onInitializeDelayed()
    }

    func initBanner(with info: CASMediationInfo) throws -> CASBannerAgent {
        if info.isDemo {
            return BannerAgent(tag: nil, ecpm: 0.0)
        }

        let settings = try info.readSettings()
        return BannerAgent(
            tag: getTag(settings, "banner_tag"),
            ecpm: (settings["banner_ecpm"] as? Double) ?? 0.0
        )
    }

    func initInterstitial(with info: CASMediationInfo) throws -> CASAgent {
        if info.isDemo {
            return InterstitialAgent(tag: nil, ecpm: 0.0, isRewarded: false)
        }

        let settings = try info.readSettings()
        return InterstitialAgent(
            tag: getTag(settings, "inter_tag"),
            ecpm: (settings["inter_ecpm"] as? Double) ?? 0.0,
            isRewarded: false
        )
    }

    func initRewarded(with info: CASMediationInfo) throws -> CASAgent {
        if info.isDemo {
            return InterstitialAgent(tag: nil, ecpm: 0.0, isRewarded: true)
        }

        let settings = try info.readSettings()
        return InterstitialAgent(
            tag: getTag(settings, "reward_tag"),
            ecpm: (settings["reward_ecpm"] as? Double) ?? 0.0,
            isRewarded: true
        )
    }

    private func getTag(_ info: [String: Any], _ field: String) -> String? {
        if let tag = info[field] as? String, !tag.isEmpty {
            return tag
        }
        return nil
    }
}

extension CASStartAppProvider: CASOptionsListener {
    func onChangedState(gdpr: CASConsentStatus) {
        STAStartAppSDK.sharedInstance()?.setUserConsent(
            gdpr == .accepted, forConsentType: "pas", withTimestamp: Int(NSDate().timeIntervalSince1970)
        )
    }

    func onChangedState(ccpa: CASCCPAStatus) {
    }

    func onChangedTagged(audience: CASAudience) {
    }

    func onChangedDebugMode(_ debug: Bool) {
    }

    func onChangedMuteAdSounds(_ muted: Bool) {
    }
}

private class BannerAgent: CASBannerAgent {
    private let tag: String?
    private let floorEcpm: Double

    private var view: STABannerView?

    init(tag: String?, ecpm: Double) {
        self.tag = tag
        floorEcpm = ecpm
        super.init(true, 3)
    }

    override func getView() -> UIView? {
        return view
    }

    override var versionInfo: String {
        return STAStartAppSDK.sharedInstance()?.version ?? ""
    }

    override func requestAd() throws {
        if loadedSize != size || loadedSizeIndex < 0 {
            let validSize = findClosestSize([
                STA_PortraitAdSize_320x50.size,
                STA_PortraitAdSize_768x90.size,
                STA_LandscapeAdSize_480x50.size,
                STA_LandscapeAdSize_568x50.size,
                STA_LandscapeAdSize_1024x90.size,
                STA_MRecAdSize_300x250.size]
            )

            if validSize < 0 {
                return
            }
        }

        if isAdReady() {
            onAdLoaded()
            return
        }

        CASHandler.main {
            if let view = self.view {
                view.loadAd()
            } else {
                self.createBanner()?.loadAd()
            }
        }
        try super.requestAd()
    }

    private func createBanner() -> STABannerView? {
        let staSize: STABannerSize
        switch loadedSizeIndex {
        case 0: staSize = STA_PortraitAdSize_320x50
        case 1: staSize = STA_PortraitAdSize_768x90
        case 2: staSize = STA_LandscapeAdSize_480x50
        case 3: staSize = STA_LandscapeAdSize_568x50
        case 4: staSize = STA_LandscapeAdSize_1024x90
        case 5: staSize = STA_MRecAdSize_300x250
        default:
            onAdWrongSize()
            return nil
        }

        let preferences = STAAdPreferences()
        if let tag = tag {
            preferences.adTag = tag
        }
        if floorEcpm > 0.0 {
            preferences.minCPM = floorEcpm
        }

        guard let newView = STABannerView(
            size: staSize,
            origin: CGPoint.zero,
            adPreferences: preferences,
            withDelegate: self
        ) else {
            onAdFailedToLoad("Cant create instance")
            return nil
        }
        if let tag = tag {
            newView.setSTABannerAdTag(tag)
        }
        view = newView
        return newView
    }

    override func disposeAd() {
        super.disposeAd()
        view = nil
    }
}

extension BannerAgent: STABannerDelegateProtocol {
    func bannerAdIsReady(toDisplay banner: STABannerView!) {
        onAdLoaded()
    }

    func failedLoadBannerAd(_ banner: STABannerView!, withError error: Error!) {
        if let error = error as NSError? {
            if error.code == STAError.noContent.rawValue {
                onAdFailedToLoad("No Fill")
            } else {
                onAdFailedToLoad("\(error.description) Code: \(error.code)")
            }
        } else {
            onAdFailedToLoad("Unknown")
        }
    }

    func didClickBannerAd(_ banner: STABannerView!) {
        onAdClicked()
    }
}

private class InterstitialAgent: CASAgent {
    private let tag: String?
    private let floorEcpm: Double
    private let isRewarded: Bool

    private var view: STAStartAppAd?

    init(tag: String?, ecpm: Double, isRewarded: Bool) {
        self.tag = tag
        floorEcpm = ecpm
        self.isRewarded = isRewarded
        super.init()
    }

    override var versionInfo: String {
        return STAStartAppSDK.sharedInstance()?.version ?? ""
    }

    override func requestAd() throws {
        CASHandler.main {
            self.createView()
        }
    }

    private func createView() {
        guard let newView = STAStartAppAd() else {
            onAdFailedToLoad("Cant be created")
            return
        }
        let preferences = STAAdPreferences()
        if let tag = tag {
            preferences.adTag = tag
        }
        if floorEcpm > 0.0 {
            preferences.minCPM = floorEcpm
        }

        // newView.staShouldAutoRotate = true
        view = newView
        if isRewarded {
            newView.loadRewardedVideoAd(withDelegate: self, with: preferences)
        } else {
            newView.load(withDelegate: self, with: preferences)
        }
    }

    override func isAdReady() -> Bool {
        return view?.isReady() == true
    }

    override func isAdCached() -> Bool {
        return view != nil && super.isAdCached()
    }

    override func showAd(_ controller: UIViewController) throws {
        guard let view = view else {
            throw CASError.nilOptional("View")
        }
        if let tag = tag {
            view.showAd(withAdTag: tag)
        } else {
            view.show()
        }
    }

    override func disposeAd() {
        super.disposeAd()
        view = nil
    }
}

extension InterstitialAgent: STADelegateProtocol {
    func didLoad(_ ad: STAAbstractAd!) {
        onAdLoaded()
    }

    func failedLoad(_ ad: STAAbstractAd!, withError error: Error!) {
        if let error = error as NSError? {
            if error.code == STAError.noContent.rawValue {
                onAdFailedToLoad("No Fill")
            } else {
                onAdFailedToLoad("\(error.description) Code: \(error.code)")
            }
        } else {
            onAdFailedToLoad("Unknown")
        }
    }

    func didShow(_ ad: STAAbstractAd!) {
        onAdShown()
    }

    func failedShow(_ ad: STAAbstractAd!, withError error: Error!) {
        if let error = error as NSError? {
            showFailed("\(error.description) Code: \(error.code)")
        } else {
            showFailed("Unknown")
        }
    }

    func didClick(_ ad: STAAbstractAd!) {
        onAdClicked()
        didClose(ad) // Start app dont call Did Cloase after click
    }

    func didClose(_ ad: STAAbstractAd!) {
        onAdWillClose()
        view = nil
        onAdClosed()
    }

    func didCompleteVideo(_ ad: STAAbstractAd!) {
        if isRewarded {
            onAdCompleted()
        }
    }
}
