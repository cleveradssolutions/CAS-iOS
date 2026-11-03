//
//  CASYaAppOpenAd.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaBannerAd: MediationAdBase, MediationBannerAd, MediationAdLoaderUI, BannerAdViewDelegate {
    private var view: BannerAdView?
    private var request: MediationBannerAdRequest?

    override init() {
        super.init()
    }

    func loadAdUI(request: MediationAdUnitRequest) {
        let bannerRequest = request.forBannerAd()
        self.request = bannerRequest

        let newView = BannerAdView(adSize: bannerRequest.getYaBannerSize())
        newView.delegate = self
        newView.frame = bannerRequest.createAdaptiveAdLayout()
        view = newView
        newView.loadAd(with: request.toYaRequest())
    }

    func createView(request: MediationBannerAdRequest, delegate: MediationAdDelegate) throws
        -> UIView
    {
        guard let view else {
            throw CASException.nilOptional("view")
        }
        return view
    }

    override func destroy() {
        super.destroy()
        DispatchQueue.main.async { [self] in
            request = nil
            view?.delegate = nil
            view = nil
        }
    }

    func bannerAdViewDidLoad(_ bannerAdView: BannerAdView) {
        creativeId = CASFindCreativeFromYangoInfo(bannerAdView.adInfo)
        request?.success(ad: self)
        request = nil
    }

    func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: any Error) {
        request?.failure(CASErrorFromYango(error))
        request = nil
    }

    func bannerAdViewDidClick(_ bannerAdView: BannerAdView) {
        delegate?.didRecordClickAd(self)
    }

    func bannerAdView(
        _ bannerAdView: BannerAdView,
        didTrackImpression impressionData: ImpressionData?
    ) {
        didTrackImpression(impressionData)
    }
}
