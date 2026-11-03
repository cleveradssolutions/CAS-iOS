//
//  CASYaNativeAdLoader.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaNativeAdLoader: NSObject, MediationAdLoaderWork {
    private var loader: NativeAdLoader?
    private var loading = false

    override init() {
        super.init()
    }

    func isLoading() -> Bool { return loading }

    func loadAd(request: MediationAdUnitRequest) {
        if loader == nil {
            self.loader = NativeAdLoader()
        }
        loading = true
        loader?
            .loadAd(
                with: request.toYaRequest(),
                // Yandex Native ad have no URI API for assets
                options: NativeAdOptions(shouldLoadImagesAutomatically: true)
            ) { [weak self] result in
                CASHandler.main {
                    self?.loading = false
                    do {
                        let ad = try result.get()
                        request.forNativeAd().success(ad: CASYaNativeAd(ad: ad))
                    } catch {
                        request.failure(CASErrorFromYango(error))
                    }
                }
            }
    }
}
