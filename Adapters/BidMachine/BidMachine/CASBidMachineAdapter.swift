//
//  CASBidMachineAdapter.swift
//  CASBidMachine
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import BidMachine
import CleverAdsSolutions
import CoreLocation

@objc(CASBidMachineProvider)
public final class CASBidMachineProvider: NSObject, MediationProvider {
    static let adapterVersion = "3.8.2.0"
    public func create() -> MediationAdapterBase {
        return CASBidMachineAdapter()
    }
}

private final class CASBidMachineAdapter: MediationRtbAdapter {

    override func getSDKVersion() -> String {
        return BidMachineSdk.sdkVersion
    }

    override func getAdapterVersion() -> String {
        return CASBidMachineProvider.adapterVersion
    }

    override func supportBidding() -> UInt {
        return MediationAdapterSupport.simple | MediationAdapterSupport.nativ
    }

    override var isInitialized: Bool {
        return BidMachineSdk.shared.isInitialized
    }

    override func initAds(request: MediationInitAdRequest) {
        guard let sourceId = request.requireAppID() else { return }

        BidMachineSdk.shared.populate {
            let debug = request.isDebugLogsEnabled
            _ =
                $0.withTestMode(request.isTestRequest)
                .withLoggingMode(debug)
                .withBidLoggingMode(debug)
                .withEventLoggingMode(false)
        }

        BidMachineSdk.shared.targetingInfo.populate {
            let options = CAS.targetingOptions
            if let userID = options.userID, !userID.isEmpty {
                _ = $0.withUserId(userID)
            }
            switch options.gender {
            case .male: _ = $0.withUserGender(.male)
            case .female: _ = $0.withUserGender(.female)
            default: break
            }
            if options.age > 0 {
                let year = Calendar.current.component(.year, from: Date()) - options.age
                _ = $0.withUserYOB(UInt32(year))
            }
            if let location = options.location {
                _ = $0.withUserLocation(location)
            }
            if let keywords = options.keywords {
                for keyword in keywords {
                    _ = $0.withKeywords(keyword)
                }
            }
        }

        // BidMachine applies the privacy of the session it was initialized in,
        // so it is set before initializeSdk and refreshed on every change.
        didChangeUserPrivacy(request.privacy)

        BidMachineSdk.shared.initializeSdk(sourceId)
        request.success()
    }

    override func didChangeUserPrivacy(_ privacy: MediationUserPrivacy) {
        BidMachineSdk.shared.regulationInfo.populate { info in
            if let coppa = privacy.isAppliesCOPPA() {
                _ = info.withCOPPA(coppa)
            }
            if let consent = privacy.getConsentString() {
                _ = info.withGDPRConsentString(consent)
            }
            if let consent = privacy.hasConsent(id: .bidMachine) {
                _ = info.withGDPRConsent(consent)
            }

            _ = info.withUSPrivacyString(privacy.getUSPrivacyString())
        }
    }

    override func collectSignals(request: MediationAdSignalRequest) {
        guard let bmFormat = getBidMachineFormat(request) else {
            // Not supported format
            super.collectSignals(request: request)
            return
        }

        do {
            let placement = try BidMachineSdk.shared.placement(bmFormat) { builder in
                if !request.unitId.isEmpty {
                    _ = builder.withPlacementId(request.unitId)
                }
            }
            BidMachineSdk.shared.token(placement: placement) { token in
                guard let token else {
                    request.failure(AdError(.internalError))
                    return
                }
                request.success(signalsData: token)
            }
        } catch {
            request.failure(CASErrorFromBidMachine(error))
        }
    }

    override func fetchAdBid(request: MediationAdBidRequest) -> MediationAdLoader? {
        guard let format = getBidMachineFormat(request) else {
            // Not supported format
            return super.fetchAdBid(request: request)
        }
        guard let auctionRequest = tryBuildAuction(request, format: format) else { return nil }
        let loader = CASBidMachineLoader(request: request)
        BidMachineSdk.shared.ad(request: auctionRequest, completion: loader.didBidRecieved)
        return loader
    }

    override func loadAd(request: MediationBannerAdRequest) -> MediationAdLoader? {
        guard let bannerSize = getBidMachineFormat(request) else {
            // Not supported banner size
            return super.loadAd(request: request)
        }
        return loadBidMahineAd(request: request, format: bannerSize)
    }

    override func loadAd(request: MediationInterstitialAdRequest) -> MediationAdLoader? {
        return loadBidMahineAd(request: request, format: BidMachine.AdFormat.interstitial)
    }

    override func loadAd(request: MediationRewardedAdRequest) -> MediationAdLoader? {
        return loadBidMahineAd(request: request, format: BidMachine.AdFormat.rewarded)
    }

    override func loadAd(request: MediationNativeAdRequest) -> MediationAdLoader? {
        return loadBidMahineAd(request: request, format: BidMachine.AdFormat.native)
    }

    private func loadBidMahineAd(request: MediationAdUnitRequest, format: BidMachine.AdFormat)
        -> MediationAdLoader?
    {
        guard let auction = tryBuildAuction(request, format: format) else { return nil }
        let loader = CASBidMachineAd(request: request)
        BidMachineSdk.shared.ad(request: auction, completion: loader.loadAdContent)
        return loader
    }

    private func getBidMachineFormat(_ request: MediationAdUnitRequest) -> BidMachine.AdFormat? {
        let bmFormat: BidMachine.AdFormat?
        if request.format.isAdView {
            let bannerRequest = request.forBannerAd()
            /// CAS size ids, which are internal to the SDK: 0 banner, 1 leaderboard, 2 medium rectangle, 3 thin.
            if bannerRequest.adSizeId == 3 {
                return nil
            }

            // BidMachine has adaptive sizes but no inline ones, so an inline request is
            // served as adaptive, except for the medium rectangle, which keeps its fixed size.
            let adSize = bannerRequest.adSize
            if adSize.isAdaptive || (adSize.isInline && bannerRequest.adSizeId != 2) {
                return BidMachine.AdFormat.bannerAdaptive(
                    width: UInt32(adSize.width),
                    maxHeight: UInt32(adSize.height)
                )
            }
            // A banner size is an ad format of its own for BidMachine.
            switch bannerRequest.adSizeId {
            case 1: return BidMachine.AdFormat.banner728x90
            case 2: return BidMachine.AdFormat.banner300x250
            default: return BidMachine.AdFormat.banner320x50
            }
        }
        switch request.format {
        case .interstitial: return BidMachine.AdFormat.interstitial
        case .rewarded: return BidMachine.AdFormat.rewarded
        case .native: return BidMachine.AdFormat.native
        default: return nil
        }
    }

    /// A Server Bidding request carries the markup of an auction that already ran on our
    /// server, so BidMachine renders it as is. The other flows let BidMachine run its own
    /// auction, bounded by the floor of the request.
    private func tryBuildAuction(
        _ request: MediationAdUnitRequest,
        format: BidMachine.AdFormat
    ) -> BidMachineAuctionRequest? {
        do {
            let placement = try BidMachineSdk.shared.placement(format) { builder in
                if !request.unitId.isEmpty {
                    _ = builder.withPlacementId(request.unitId)
                }
            }

            return BidMachineSdk.shared.auctionRequest(placement: placement) { builder in
                if let payload = request.bidResponse {
                    _ = builder.withPayload(payload)
                } else if request.floor > 0 {
                    _ = builder.appendPriceFloor(request.floor, UUID().uuidString)
                }
            }
        } catch {
            request.failure(CASErrorFromBidMachine(error))
            return nil
        }
    }
}

/// BidMachine reports its kind of failure in the code of the NSError, and
/// leaves the error out altogether when it answers with no ad at all.
func CASErrorFromBidMachine(_ error: Error?) -> AdError {
    guard let error else {
        return AdError(.internalError, "BidMachine returned no ad and no error")
    }
    let errorCode = (error as NSError).code
    switch errorCode {
    case 100,  // No connection
        102:  // Timeout
        return AdError.noConnection
    case 103:  // No content
        return AdError.noFill
    case 101,  // Bad Content
        106:  // Ad destroyed
        return AdError.notReady
    case 107:  // Ad expired
        return AdError.expired
    default:
        return AdError(error.localizedDescription + " (c\(errorCode)")
    }
}
