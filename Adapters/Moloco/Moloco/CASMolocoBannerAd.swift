//
//  CASMolocoBannerAd.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK

final class CASMolocoBannerAd: MediationAdBase, MediationBannerAd, MediationAdLoader,
    MolocoBannerDelegate
{

    private let view: MolocoBannerAdView
    private var request: MediationBannerAdRequest?

    init(ad: MolocoBannerAdView, request: MediationBannerAdRequest) {
        self.view = ad
        self.request = request
        super.init()
    }

    override func destroy() {
        super.destroy()
        view.destroy()
        request = nil
    }

    func createView(request: MediationBannerAdRequest, delegate: MediationAdDelegate) throws
        -> UIView
    {
        if request.format == AdSize.mediumRectangle {
            delegate.didRecordAdImpression(self)
        }
        return view
    }

    // MARK: - MolocoBannerDelegate

    func didLoad(ad: MolocoAd) {
        guard let request else { return }
        self.request = nil
        creativeId = ad.creativeId as? String

        // Moloco SDK delivers didLoad on the main queue after sizing, so the size is final here.
        // Fixed-size banners have no intrinsic size (-1) and are reported without extra info.
        let adSize = view.intrinsicContentSize
        if adSize.width > 0, adSize.height > 0 {
            view.frame = CGRect(origin: .zero, size: adSize)
        } else {
            view.frame = request.createAdLayout()
        }

        request.success(ad: self)
    }

    func failToLoad(ad: MolocoAd, with error: Error?) {
        guard let request else { return }
        self.request = nil
        request.failure(CASErrorFromMoloco(error))
    }

    func didShow(ad: MolocoAd) {
        // NOTE: Only banners will receive the callback as MRECs are not currently supported
        delegate?.didRecordAdImpression(self)
    }

    func failToShow(ad: MolocoAd, with error: Error?) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromMoloco(error))
    }

    func didClick(on ad: MolocoAd) {
        delegate?.didRecordClickAd(self)
    }

    func didHide(ad: MolocoAd) {}
}
