//
//  CASMolocoAdapter.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK

@objc(CASMolocoProvider)
public final class CASMolocoProvider: NSObject, MediationProvider {
    public func create() -> MediationAdapterBase {
        return CASMolocoAdapter()
    }
}

private final class CASMolocoAdapter: MediationAdapterBase {
    private var mediationName: String = "cas"

    override func getAdapterVersion() -> String {
        return "4.11.1.0"
    }

    override func getSDKVersion() -> String {
        Moloco.shared.sdkVersion
    }

    override var isInitialized: Bool {
        Moloco.shared.isInitialized
    }

    override func supportBidding() -> UInt {
        return MediationAdapterSupport.banner | MediationAdapterSupport.nativ
            | MediationAdapterSupport.mrec | MediationAdapterSupport.inter
            | MediationAdapterSupport.reward | MediationAdapterSupport.max
            | MediationAdapterSupport.iron
    }

    override func initAds(request: MediationInitAdRequest) {
        guard let appKey = request.requireAppID() else { return }
        if let name = request.getStrParameter(MediationKey.mediationName) {
            mediationName = name
        }

        Moloco.shared.initialize(
            params: .init(appKey: appKey, mediation: mediationName)
        ) { [weak self] success, error in
            if success {
                self?.didChangeUserPrivacy(request.privacy)
                request.success()
            } else {
                request.failure(AdError(.notInitialized, error?.localizedDescription))
            }
        }
    }

    override func collectSignals(request: MediationAdSignalRequest) {
        didChangeUserPrivacy(request.privacy)
        Moloco.shared.getBidToken(params: .init(mediation: mediationName)) { signal, error in
            if let error {
                request.failure(CASErrorFromMoloco(error))
            } else if let signal {
                request.success(signalsData: signal)
            } else {
                request.failure(AdError(.internalError))
            }
        }
    }

    override func loadAd(request: MediationBannerAdRequest) -> MediationAdLoader? {
        if request.adSize.height < 50 {
            return super.loadAd(request: request)
        }
        guard let bidResponse = requireBidResponse(for: request) else { return nil }
        guard let controller = request.requireUIContext() else { return nil }

        return MainActor.assumeIsolated {
            let params = MolocoCreateAdParams(adUnit: request.unitId, mediation: mediationName)
            let size = molocoBannerAdSize(for: request)
            guard
                let banner = Moloco.shared.createMolocoBanner(
                    params: params,
                    size: size,
                    viewController: controller
                )
            else {
                request.failure(AdError(.configurationError))
                return nil
            }
            let laoder = CASMolocoBannerAd(ad: banner, request: request)
            banner.delegate = laoder
            banner.load(bidResponse: bidResponse)
            return laoder
        }
    }

    override func loadAd(request: MediationInterstitialAdRequest) -> MediationAdLoader? {
        guard let bidResponse = requireBidResponse(for: request) else { return nil }

        return MainActor.assumeIsolated {
            if let ad = Moloco.shared.createInterstitial(
                params: MolocoCreateAdParams(adUnit: request.unitId, mediation: mediationName)
            ) {
                let loader = CASMolocoScreenAd(ad: ad, request: request)
                ad.interstitialDelegate = loader
                ad.load(bidResponse: bidResponse)
                return loader
            }
            request.failure(AdError(.configurationError))
            return nil
        }
    }

    override func loadAd(request: MediationRewardedAdRequest) -> MediationAdLoader? {
        guard let bidResponse = requireBidResponse(for: request) else { return nil }

        return MainActor.assumeIsolated {
            if let ad = Moloco.shared.createRewarded(
                params: MolocoCreateAdParams(adUnit: request.unitId, mediation: mediationName)
            ) {
                let loader = CASMolocoScreenAd(ad: ad, request: request)
                ad.rewardedDelegate = loader
                ad.load(bidResponse: bidResponse)
                return loader
            }
            request.failure(AdError(.configurationError))
            return nil
        }
    }

    override func loadAd(request: MediationNativeAdRequest) -> MediationAdLoader? {
        guard let bidResponse = requireBidResponse(for: request) else { return nil }

        return MainActor.assumeIsolated {
            if let nativeAd = Moloco.shared.createNativeAd(
                params: MolocoCreateAdParams(adUnit: request.unitId, mediation: mediationName)
            ) {
                let loader = CASMolocoNativeLoader(nativeAd: nativeAd, request: request)
                nativeAd.delegate = loader
                nativeAd.load(bidResponse: bidResponse)
                return loader
            }
            request.failure(AdError(.configurationError))
            return nil
        }
    }

    override func didChangeUserPrivacy(_ privacy: any MediationUserPrivacy) {
        if let hasConsent = privacy.hasConsent(id: .moloco) {
            MolocoPrivacySettings.hasUserConsent = hasConsent
        }
        if let isDoNotSell = privacy.isOptOutSaleUS() {
            MolocoPrivacySettings.isDoNotSell = isDoNotSell
        }
        if let coppa = privacy.isAppliesCOPPA() {
            MolocoPrivacySettings.isAgeRestrictedUser = coppa
        }
    }

    private func requireBidResponse(for request: MediationAdUnitRequest) -> String? {
        if let bid = request.bidResponse {
            return bid
        }
        request.failure(AdError(.noFill, "Requires bid response"))
        return nil
    }

    private func molocoBannerAdSize(for request: MediationBannerAdRequest) -> MolocoBannerAdSize {
        let adSize = request.adSize
        if request.adSizeId == 2 {
            return .mrec
        }
        if adSize.isAdaptive {
            return .anchoredAdaptive(width: Int(adSize.width))
        } else if adSize.isInline {
            return .inlineAdaptive(width: Int(adSize.width))
        }
        return .standard
    }
}
