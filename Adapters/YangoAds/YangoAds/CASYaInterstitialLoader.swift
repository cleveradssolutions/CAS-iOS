//
//  CASYaInterstitialLoader.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaInterstitialLoader: NSObject, MediationAdLoaderWork {
    private var loader: InterstitialAdLoader?
    private var loading = false

    override init() {
        super.init()
    }

    func isLoading() -> Bool { return loading }

    func loadAd(request: MediationAdUnitRequest) {
        if loader == nil {
            self.loader = InterstitialAdLoader()
        }
        loading = true
        loader?.loadAd(with: request.toYaRequest()) { [weak self] result in
            CASHandler.main {
                self?.loading = false
                do {
                    let ad = try result.get()
                    request.forScreenAd().success(ad: CASYaInterstitialAd(view: ad))
                } catch {
                    request.failure(CASErrorFromYango(error))
                }
            }
        }
    }
}
