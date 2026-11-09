//
//  CASYaAppOpenLoader.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaAppOpenLoader: NSObject, MediationAdLoaderWork {
    private var loader: AppOpenAdLoader?
    private var loading = false

    override init() {
        super.init()
    }

    func isLoading() -> Bool { return loading }

    func loadAd(request: MediationAdUnitRequest) {
        if !request.requirePortraitOrientationOnly() {
            return
        }
        if loader == nil {
            let newLoader = AppOpenAdLoader()
            self.loader = newLoader
        }
        loading = true
        loader?.loadAd(with: request.toYaRequest()) { [weak self] ad, error in
            CASHandler.main {
                self?.loading = false
                if let error = error {
                    request.failure(CASErrorFromYango(error))
                } else {
                    request.forScreenAd().success(ad: CASYaAppOpenAd(view: ad!))
                }
            }
        }
    }
}
