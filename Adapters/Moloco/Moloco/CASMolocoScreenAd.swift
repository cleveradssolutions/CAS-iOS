//
//  CASMolocoScreenAd.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK

final class CASMolocoScreenAd: MediationAdBase, MediationScreenAd, MediationAdLoader,
    MolocoInterstitialDelegate, MolocoRewardedDelegate
{
    private let ad: MolocoFullscreenAd
    private var request: MediationScreenAdRequest?

    init(ad: MolocoFullscreenAd, request: MediationScreenAdRequest) {
        self.ad = ad
        self.request = request
        super.init()

    }

    override func destroy() {
        super.destroy()
        ad.destroy()
        request = nil
    }

    func presentScreen(delegate: MediationAdDelegate) {
        guard ad.isReady else {
            delegate.didFailToPresentAd(self, error: AdError.notReady)
            return
        }

        guard let controller = delegate.requireUIController(self) else { return }

        MainActor.assumeIsolated {
            ad.show(from: controller)
        }
    }

    // MARK: - MolocoInterstitialDelegate

    func didLoad(ad: MolocoAd) {
        guard let request else { return }
        self.request = nil
        creativeId = ad.creativeId as? String

        request.success(ad: self)
    }

    func failToLoad(ad: MolocoAd, with error: Error?) {
        guard let request else { return }
        self.request = nil
        request.failure(CASErrorFromMoloco(error))
    }

    func didShow(ad: MolocoAd) {
        delegate?.didRecordAdImpression(self)
    }

    func failToShow(ad: MolocoAd, with error: Error?) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromMoloco(error))
    }

    func didClick(on ad: MolocoAd) {
        delegate?.didRecordClickAd(self)
    }

    func didHide(ad: MolocoAd) {
        delegate?.didDismissScreenAd(self)
    }

    // MARK: - MolocoRewardedDelegate

    func rewardedVideoStarted(ad: MolocoAd) {}

    func rewardedVideoCompleted(ad: MolocoAd) {}

    func userRewarded(ad: MolocoAd) {
        delegate?.didUserEarnReward(from: self)
    }
}
