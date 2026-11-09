//
//  CASYaRewardedLoader.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

class CASYaRewardedLoader: NSObject, MediationAdLoaderWork {
    private var loader: RewardedAdLoader?
    private var loading = false

    override init() {
        super.init()
    }
    
    func isLoading() -> Bool { return loading }

    func loadAd(request: MediationAdUnitRequest) {
        if loader == nil {
            self.loader = RewardedAdLoader()
        }
        loading = true
        loader?.loadAd(with: request.toYaRequest()) { [weak self] result in
            CASHandler.main {
                self?.loading = false
                do {
                    let ad = try result.get()
                    request.forScreenAd().success(ad: CASYaRewardedAd(view: ad))
                } catch {
                    request.failure(CASErrorFromYango(error))
                }
            }
        }
    }
}
