//
//  CASYaNativeAd.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaNativeAd: MediationNativeAdContent, NativeAdDelegate {
    private let ad: NativeAd
    private let assets: NativeAdAssets
    private let videoContent: Bool

    init(ad: NativeAd) {
        self.ad = ad
        self.assets = ad.adAssets()
        videoContent = ad.adType == .media
        super.init()
        ad.delegate = self
        hasMediaContent = assets.media != nil || assets.image != nil
        hasAdChoices = assets.feedbackAvailable
        creativeId = CASFindCreativeFromYangoInfo(ad.adInfo)
    }

    // Required assets:
    // title, domain, warning, sponsored, feedback, callToAction, media, icon, price

    override var headline: String? { assets.title }
    override var callToAction: String? { assets.callToAction }
    override var price: String? { assets.price }

    override var advertiser: String? {
        // Yandex Ads have sponsored and domain in same ad, and required present it
        assets.domain
    }

    override var adLabel: String? {
        // assets.age included to sponsored
        assets.sponsored
    }

    override var body: String? {
        // Body content is optional, but required present Warning content to user
        return assets.warning?.value ?? assets.body
    }

    override var icon: UIImage? {
        // The Icon can be nil for not app content, but the favicon is too small to use as icon asset.
        assets.icon?.imageValue
    }

    override var mediaImage: UIImage? { assets.image?.imageValue }

    // Optional assets:
    override var starRating: NSNumber? { assets.rating }
    override var reviewCount: String? { assets.reviewCount }
    override var hasVideoContent: Bool { videoContent }
    override var mediaContentAspectRatio: CGFloat {
        if hasMediaContent {
            if let media = assets.media {
                return media.aspectRatio
            }
            if let imageSize = assets.image?.size {
                return imageSize.width / imageSize.height
            }
        }
        return super.mediaContentAspectRatio
    }

    override func createAdChoicesContent(frame: CGRect) -> UIView? {
        assets.feedbackAvailable ? UIButton(frame: frame) : nil
    }

    override func createMediaContent(frame: CGRect) -> UIView? {
        // Media View can be null and not presented if media has not video and no image
        hasMediaContent ? NativeMediaView(frame: frame) : nil
    }

    override func didRender(
        in view: UIView,
        assets: NativeAdAssetViews,
        delegate: MediationAdDelegate
    ) {
        MainActor.assumeIsolated {
            let data = NativeAdViewData()
            data.titleLabel = assets.headlineView
            data.domainLabel = assets.advertiserView
            data.callToActionButton = assets.callToActionView
            data.sponsoredLabel = assets.adLabelView
            data.priceLabel = assets.priceView
            data.reviewCountLabel = assets.reviewCountView
            data.iconImageView = assets.iconView
            data.mediaView = assets.mediaView?.subviews.first as? NativeMediaView
            data.feedbackButton = assets.adChoicesView?.subviews.first as? UIButton

            // required YandexMobileAds.Rating implementation
            // data.ratingView = assets.starRatingView

            if let bodyView = assets.bodyView {
                if self.assets.warning != nil {
                    data.warningLabel = bodyView
                } else {
                    data.bodyLabel = bodyView
                }
            }

            do {
                try ad.bindAd(to: view, viewData: data)
            } catch {
                delegate.didFailToPresentAd(
                    self,
                    error: AdError(error.localizedDescription, cause: error)
                )
            }
        }
    }

    func nativeAdDidClick(_ ad: NativeAd) {
        delegate?.didRecordClickAd(self)
    }

    func nativeAd(_ ad: any NativeAd, didTrackImpression impressionData: ImpressionData?) {
        didTrackImpression(impressionData)
    }
}
