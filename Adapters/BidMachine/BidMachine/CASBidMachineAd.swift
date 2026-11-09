//
//  CASBidMachineRewardedAd.swift
//  CASBidMachine
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import BidMachine
import CleverAdsSolutions

final class CASBidMachineAd: MediationAdBase, MediationScreenAd, MediationBannerAd,
    MediationAdLoader, BidMachineAdDelegate
{
    var ad: BidMachineAdProtocol?
    var request: MediationAdUnitRequest?

    init(request: MediationAdUnitRequest) {
        self.request = request
        super.init()
    }

    func loadAdContent(_ ad: BidMachineAdProtocol?, error: Error?) {
        guard let ad = ad else {
            self.request?.failure(CASErrorFromBidMachine(error))
            self.request = nil
            return
        }
        self.ad = ad
        ad.delegate = self
        ad.loadAd()
    }

    override func destroy() {
        super.destroy()
        ad?.delegate = nil
        ad = nil
        request = nil
    }

    // MARK: MediationScreenAd

    func presentScreen(delegate: MediationAdDelegate) {
        guard let ad = ad, ad.canShow else {
            delegate.didFailToPresentAd(self, error: AdError.notReady)
            return
        }
        guard let controller = delegate.requireUIController(self) else { return }
        ad.controller = controller
        if let interstitialAd = ad as? BidMachineInterstitial {
            interstitialAd.presentAd()
        } else if let rewardedAd = ad as? BidMachineRewarded {
            rewardedAd.presentAd()
        }
    }

    // MARK: MediationBannerAd

    func createView(request: MediationBannerAdRequest, delegate: MediationAdDelegate) throws
        -> UIView
    {
        guard let adView = ad as? BidMachineBanner else {
            throw AdError.notReady
        }
        let layout = request.createAdaptiveAdLayout()
        adView.frame = layout

        // The frame alone does not hold: CAS lays the ad view out with Auto Layout,
        // and BidMachine then constrains its own view to zero.
        NSLayoutConstraint.activate([
            adView.widthAnchor.constraint(equalToConstant: layout.width),
            adView.heightAnchor.constraint(equalToConstant: layout.height),
        ])

        return adView
    }

    // MARK: BidMachineAdDelegate

    func didLoadAd(_ ad: any BidMachineAdProtocol) {
        guard let request = request else { return }
        creativeId = ad.auctionInfo.creativeId
        if request.format.isAdView {
            request.forBannerAd().success(ad: self)
        } else if request.format == .native {
            if let nativeAd = ad as? BidMachineNative {
                request.forNativeAd().success(ad: CASBidMachineNativeAd(ad: nativeAd))
            } else {
                request.failure(AdError("Invalid Ad type loaded for native ad format"))
            }
        } else {
            request.forScreenAd().success(ad: self)
        }
        self.request = nil
    }

    func didFailLoadAd(_ ad: any BidMachineAdProtocol, _ error: any Error) {
        request?.failure(CASErrorFromBidMachine(error))
        request = nil
    }

    func didPresentAd(_ ad: any BidMachineAdProtocol) {
        delegate?.willPresentScreenAd(self)
    }

    func didFailPresentAd(_ ad: any BidMachineAdProtocol, _ error: any Error) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromBidMachine(error))
    }

    func didTrackImpression(_ ad: any BidMachineAdProtocol) {
        delegate?.didRecordAdImpression(self)
    }

    func didUserInteraction(_ ad: any BidMachineAdProtocol) {
        delegate?.didRecordClickAd(self)
    }

    func didReceiveReward(_ ad: any BidMachineAdProtocol) {
        delegate?.didUserEarnReward(from: self)
    }

    func didDismissAd(_ ad: any BidMachineAdProtocol) {
        delegate?.didDismissScreenAd(self)
    }

    func didExpired(_ ad: any BidMachineAdProtocol) {
        setAdExpired()
    }
}
