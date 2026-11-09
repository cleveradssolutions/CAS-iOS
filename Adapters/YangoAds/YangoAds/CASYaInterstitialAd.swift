//
//  CASYaInterstitialAd.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaInterstitialAd: MediationAdBase, MediationScreenAd, InterstitialAdDelegate {
    private let view: InterstitialAd
    init(view: InterstitialAd) {
        self.view = view
        super.init()
        creativeId = CASFindCreativeFromYangoInfo(view.adInfo)
    }

    func presentScreen(delegate: MediationAdDelegate) {
        // fire didFailToShow with nil controller
        guard let controller = delegate.requireUIController(self) else { return }
        view.delegate = self
        view.show(from: controller)
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: any Error) {
        delegate?.didFailToPresentAd(self, error: AdError(error.localizedDescription))
    }

    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        delegate?.willPresentScreenAd(self)
    }

    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        delegate?.didRecordClickAd(self)
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        delegate?.didDismissScreenAd(self)
    }

    func interstitialAd(
        _ interstitialAd: InterstitialAd,
        didTrackImpression impressionData: ImpressionData?
    ) {
        didTrackImpression(impressionData)
    }
}
