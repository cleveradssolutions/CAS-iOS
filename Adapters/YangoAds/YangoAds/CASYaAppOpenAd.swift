//
//  CASYaAppOpenAd.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaAppOpenAd: MediationAdBase, MediationScreenAd, AppOpenAdDelegate {
    private let view: AppOpenAd
    init(view: AppOpenAd) {
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

    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShow error: any Error) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromYango(error))
    }

    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        delegate?.willPresentScreenAd(self)
    }

    func appOpenAdDidClick(_ appOpenAd: AppOpenAd) {
        delegate?.didRecordClickAd(self)
    }

    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        delegate?.didDismissScreenAd(self)
    }

    func appOpenAd(
        _ appOpenAd: AppOpenAd,
        didTrackImpression impressionData: ImpressionData?
    ) {
        didTrackImpression(impressionData)
    }
}
