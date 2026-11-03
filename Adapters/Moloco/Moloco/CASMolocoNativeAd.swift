//
//  CASMolocoNativeAd.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK
import UIKit

final class CASMolocoNativeAd: MediationNativeAdContent, MolocoNativeAdDelegate {

    private let nativeAd: MolocoNativeAd
    private let molocoAssets: MolocoNativeAdAssests

    init(nativeAd: MolocoNativeAd, assets: MolocoNativeAdAssests) {
        self.nativeAd = nativeAd
        self.molocoAssets = assets
        super.init()
        nativeAd.delegate = self
    }

    override func destroy() {
        super.destroy()
        nativeAd.delegate = nil
        nativeAd.destroy()
    }

    override var headline: String? { molocoAssets.title }
    override var body: String? { molocoAssets.description }
    override var callToAction: String? { molocoAssets.ctaTitle }
    override var advertiser: String? { molocoAssets.sponsorText }
    override var icon: UIImage? { molocoAssets.appIcon }
    override var starRating: NSNumber? { molocoAssets.rating as NSNumber }
    override var hasVideoContent: Bool { molocoAssets.videoView != nil }
    override var mediaImage: UIImage? { molocoAssets.mainImage }

    override func createMediaContent(frame: CGRect) -> UIView? {
        if let videoView = molocoAssets.videoView {
            videoView.frame = frame
            return videoView
        }
        // Fallback create MediaView for Media Image in super
        return super.createMediaContent(frame: frame)
    }

    override func didRender(
        in view: UIView,
        assets: NativeAdAssetViews,
        delegate: MediationAdDelegate
    ) {
        overrideClickHandling(for: assets.clickableViews)
        overrideImpressionHandling(for: view)
    }

    override func performUserClick(on assetView: UIView?) {
        nativeAd.handleClick()
    }

    override func performViewImpression() {
        nativeAd.handleImpression()
    }

    // MARK: - MolocoNativeAdDelegate

    func didHandleImpression(ad: MolocoAd) {
        delegate?.didRecordAdImpression(self)
    }

    func didHandleClick(ad: MolocoAd) {
        delegate?.didRecordClickAd(self)
    }

    func failToShow(ad: MolocoAd, with error: Error?) {
        delegate?.didFailToPresentAd(self, error: CASErrorFromMoloco(error))
    }

    func didLoad(ad: MolocoAd) {}
    func failToLoad(ad: MolocoAd, with error: Error?) {}
    func didShow(ad: MolocoAd) {}
    func didClick(on ad: MolocoAd) {}
    func didHide(ad: MolocoAd) {}
}
