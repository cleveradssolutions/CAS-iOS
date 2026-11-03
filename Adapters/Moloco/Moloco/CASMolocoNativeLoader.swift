//
//  CASMolocoNativeLoader.swift
//  CASMoloco
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import MolocoSDK
import UIKit

final class CASMolocoNativeLoader: NSObject, MediationAdLoader, MolocoNativeAdDelegate {

    private var nativeAd: MolocoNativeAd
    private var request: MediationNativeAdRequest?

    init(nativeAd: MolocoNativeAd, request: MediationNativeAdRequest) {
        self.nativeAd = nativeAd
        self.request = request
        super.init()
    }
    
    // MARK: - MolocoNativeAdDelegate
    
    func didLoad(ad: MolocoAd) {
        guard let request = request else { return }
        self.request = nil

        guard nativeAd.isReady, let assets = nativeAd.assets else {
            request.failure(AdError.notReady)
            return
        }

        let casAd = CASMolocoNativeAd(nativeAd: nativeAd, assets: assets)
//        if let cpm = ad.revenue ?? nil {
//            casAd.costPerMille = cpm.doubleValue
//        }
        casAd.creativeId = ad.creativeId as? String
        request.success(ad: casAd)
    }

    func failToLoad(ad: MolocoAd, with error: Error?) {
        request?.failure(CASErrorFromMoloco(error))
        request = nil
    }
    
    func didShow(ad: MolocoAd) {}
    func failToShow(ad: MolocoAd, with error: Error?) {}
    func didHide(ad: MolocoAd) {}
    func didClick(on ad: MolocoAd) {}
}
