//
//  CASYandexUtils.swift
//  CASYandexAds
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import YandexMobileAds

internal func CASErrorFromYango(_ error: Error) -> AdError {
    return AdError(error.localizedDescription)
}

internal func CASFindCreativeFromYangoInfo(_ info: AdInfo?) -> String? {
    guard let creatives = info?.creatives else { return nil }
    for creative in creatives {
        if let id = creative.creativeID {
            return id
        }
    }
    return nil
}

extension MediationAdUnitRequest {

    func toYaRequest() -> AdRequest {
        let targeting = CAS.targetingOptions
        return AdRequest(
            adUnitID: unitId,
            targeting: AdTargeting(
                age: targeting.age > 0 ? NSNumber(value: targeting.age) : nil,
                gender: targeting.gender == .male
                    ? .male : targeting.gender == .female ? .female : nil,
                contextTags: targeting.keywords
            ),
            adTheme: AdTheme.unspecified,
            biddingData: bidResponse
        )
    }

    /**
     * App open ads can only be placed in an application with a vertical orientation.
     * For horizontal orientation, the ads will not be selected.
     */
    func requirePortraitOrientationOnly() -> Bool {
        var landscapeOnly = false
        CASHandler.awaitMain(0) {
            landscapeOnly =
                UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape
                == true
        }
        if landscapeOnly {
            failure(
                AdError(
                    AdErrorCode.rejected,
                    "Yandex Ads support Portrait orientation only"
                )
            )
            return false
        }
        return true
    }
}

extension MediationBannerAdRequest {
    func getYaBannerSize() -> BannerAdSize {
        if adSize.isAdaptive || adSize.isInline {
            return BannerAdSize.inline(width: adSize.width, maxHeight: adSize.height)
        }
        return BannerAdSize.fixed(width: adSize.width, height: adSize.height)
    }
}

extension MediationAd {
    func didTrackImpression(_ data: ImpressionData?) {
        /**
         * For example: {
         * "currency":"RUB",
         * "revenueUSD":"0.000112202",
         * "precision":"estimated",
         * "revenue":"0.007727661",
         * "requestId":"xxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxx-production-app-host-sas-pcode-xxx",
         * "blockId":"R-M-xxxxxxx-xx",
         * "adType":"interstitial",
         * "ad_unit_id":"R-M-xxxxxxx-xx",
         * "network":{"name":"Yandex","adapter":"Yandex","ad_unit_id":"R-M-xxxxxxx-xx"}
         * }
         */
        if let data = data, !data.rawData.isEmpty {
            #if DEBUG
                delegate?.debug("(D) Impression data: " + data.rawData)
            #endif
            if let rawJson = data.rawData.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: rawJson) as? [String: Any]
            {
                // Revenue per impression converted to USD.
                if let revenue = json["revenueUSD"] as? NSNumber {
                    costPerMille = revenue.doubleValue * 1000.0
                    revenuePrecision =
                        json["precision"] as? String == "estimated"
                        ? AdRevenuePrecision.estimated
                        : AdRevenuePrecision.floor
                }
            }
        }
        delegate?.didRecordAdImpression(self)
    }
}
