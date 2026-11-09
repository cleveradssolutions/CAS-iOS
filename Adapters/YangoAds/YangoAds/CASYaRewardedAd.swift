//
//  CASYaRewardedAd.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaRewardedAd: MediationAdBase, MediationScreenAd, RewardedAdDelegate {
    private let view: RewardedAd
    init(view: RewardedAd) {
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

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShow error: any Error) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromYango(error))
    }

    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        delegate?.willPresentScreenAd(self)
    }

    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        delegate?.didRecordClickAd(self)
    }

    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        delegate?.didDismissScreenAd(self)
    }

    func rewardedAd(
        _ rewardedAd: RewardedAd,
        didTrackImpression impressionData: ImpressionData?
    ) {
        didTrackImpression(impressionData)
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: any Reward) {
        delegate?.didUserEarnReward(from: self)
    }
}
