//
//  CASYandexAdsAdapter.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

@objc(CASYandexProvider)
public final class CASYandexProvider: NSObject, MediationProvider {
    public func create() -> MediationAdapterBase {
        return CASYangoAdsAdapter()
    }
}

private final class CASYangoAdsAdapter: MediationAdapterBase {
    private var loaderToken: BidderTokenLoader?
    private var loaderAppOpen = CASYaAppOpenLoader()
    private var loaderInterstitial = CASYaInterstitialLoader()
    private var loaderRewarded = CASYaRewardedLoader()
    private var loaderNative = CASYaNativeAdLoader()

    override func getSDKVersion() -> String { YandexAds.sdkVersion.stringValue }
    override func getAdapterVersion() -> String {
        return "8.6.0.0"
    }

    override func supportBidding() -> UInt {
        return MediationAdapterSupport.allFormats
            | MediationAdapterSupport.cas
            | MediationAdapterSupport.max
            | MediationAdapterSupport.iron
    }

    // Invoke from UI Thread by AdSourceConfig in CAS Framework
    override func initAds(request: MediationInitAdRequest) {
        if request.isDebugLogsEnabled {
            YandexAds.enableLogging()
        }
        didChangeUserPrivacy(request.privacy)
        YandexAds.enableVisibilityErrorIndicator(for: request.isTestRequest ? .hardware : .none)

        // Not tested
        // MobileAds.audioSessionManager().isAutomaticallyManaged = !request.isAudioSessionAppManaged

        YandexAds
            .setAdapterIdentity(
                AdapterIdentity(
                    adapterNetworkName: request.getStrParameter(MediationKey.mediationName)
                        ?? "cas",
                    adapterVersion: request.getStrParameter(MediationKey.mediationSDKVer)
                        ?? CAS.getSDKVersion(),
                    adapterNetworkVersion: getAdapterVersion()
                )
            )
        YandexAds.initializeSDK {
            request.success()
        }
    }

    override func collectSignals(request: MediationAdSignalRequest) {
        if request.format == AdFormat.appOpen && !request.requirePortraitOrientationOnly() {
            return
        }

        let config: BidderTokenRequest
        if request.format.isAdView {
            config = .banner(size: request.forBannerAd().getYaBannerSize())
        } else {
            switch request.format {
            case AdFormat.interstitial:
                config = .interstitial()
            case AdFormat.rewarded:
                config = .rewarded()
            case AdFormat.appOpen:
                config = .appOpenAd()
            case AdFormat.native:
                config = .native()
            default:
                request.failure(
                    AdError(AdErrorCode.rejected, "Unsupported ad format: \(request.format)")
                )
                return
            }
        }

        if loaderToken == nil {
            loaderToken = BidderTokenLoader()
        }
        
        Task {
            let token = await loaderToken?.loadBidderToken(request: config)
            request.success(signalsData: token ?? "")
        }
    }

    override func loadAd(request: MediationBannerAdRequest) -> MediationAdLoader? {
        if request.adSize.height < 50 {
            return super.loadAd(request: request)
        }
        return CASYaBannerAd()
    }

    override func loadAd(request: MediationInterstitialAdRequest) -> MediationAdLoader? {
        if loaderInterstitial.isLoading() {
            return CASYaInterstitialLoader()
        }
        return loaderInterstitial
    }

    override func loadAd(request: MediationAppOpenAdRequest) -> MediationAdLoader? {
        if loaderAppOpen.isLoading() {
            return CASYaAppOpenLoader()
        }
        return loaderAppOpen
    }

    override func loadAd(request: MediationRewardedAdRequest) -> MediationAdLoader? {
        if loaderRewarded.isLoading() {
            return CASYaRewardedLoader()
        }
        return loaderRewarded
    }

    override func loadAd(request: MediationNativeAdRequest) -> MediationAdLoader? {
        if loaderNative.isLoading() {
            return CASYaNativeAdLoader()
        }
        return loaderNative
    }

    override func didChangeUserPrivacy(_ privacy: MediationUserPrivacy) {
        YandexAds.setLocationTracking(CAS.targetingOptions.locationCollectionEnabled)

        if let coppa = privacy.isAppliesCOPPA() {
            YandexAds.setAgeRestricted(coppa)
        }
        if let gdpr = privacy.hasConsent(id: AdSourceId.yangoAds) {
            YandexAds.setUserConsent(gdpr)
        }
    }
}
