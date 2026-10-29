//
//  CASBidMachineNativeAd.swift
//  CASBidMachine
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import BidMachine
import CleverAdsSolutions
import UIKit

final class CASBidMachineNativeAd: MediationNativeAdContent, BidMachineAdDelegate {

    private let ad: BidMachineNative
    private var rendering: CASBidMachineNativeRendering?

    init(ad: BidMachineNative) {
        self.ad = ad
        super.init()
        ad.delegate = self
    }

    override var headline: String? { ad.title }
    override var body: String? { ad.body }
    override var callToAction: String? { ad.cta }
    override var iconURL: URL? { ad.icon.flatMap(URL.init(string:)) }
    override var mediaImageURL: URL? { ad.main.flatMap(URL.init(string:)) }

    override var isExpired: Bool {
        return super.isExpired || !ad.canShow
    }

    override func destroy() {
        super.destroy()
        ad.delegate = nil
        ad.controller = nil
        rendering = nil
    }

    /// BidMachine renders the media and the AdChoices itself, it only needs a view
    /// of its own to draw into.
    override func createMediaContent(frame: CGRect) -> UIView? {
        return UIView(frame: frame)
    }

    override func createAdChoicesContent(frame: CGRect) -> UIView? {
        return UIView(frame: frame)
    }

    override func didRender(
        in view: UIView,
        assets: NativeAdAssetViews,
        delegate: MediationAdDelegate
    ) {
        let rendering = CASBidMachineNativeRendering(assets: assets)
        self.rendering = rendering
        ad.controller = delegate.topUIController
        do {
            ad.registerDefaultAssetsForInteraction()
            try ad.presentAd(view, rendering)
        } catch {
            delegate.didFailToPresentAd(self, error: CASErrorFromBidMachine(error))
        }
    }

    override func didDetach(from view: UIView, assets: NativeAdAssetViews) {
        super.didDetach(from: view, assets: assets)
        ad.unregisterView()
        rendering = nil
    }

    // MARK: BidMachineAdDelegate

    func didLoadAd(_ ad: any BidMachineAdProtocol) {
        // implementation in CASBidMahineAd
    }

    func didFailLoadAd(_ ad: any BidMachineAdProtocol, _ error: any Error) {
        // implementation in CASBidMahineAd
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

    func didExpired(_ ad: any BidMachineAdProtocol) {
        setAdExpired()
    }
}

/// Maps the asset views that CAS laid out onto the outlets BidMachine draws into.
/// The call to action of CAS is a button, BidMachine asks for a label, so its own
/// title label is handed over.
final class CASBidMachineNativeRendering: NSObject, BidMachineNativeAdRendering {

    private weak var assets: NativeAdAssetViews?

    init(assets: NativeAdAssetViews) {
        self.assets = assets
        super.init()
    }

    var titleLabel: UILabel? { assets?.headlineView }
    var descriptionLabel: UILabel? { assets?.bodyView }
    var callToActionLabel: UILabel? { assets?.callToActionView?.titleLabel }
    var iconView: UIImageView? { assets?.iconView }
    var mediaContainerView: UIView? { assets?.mediaView?.subviews.first }
    var adChoiceView: UIView? { assets?.adChoicesView?.subviews.first }
}
