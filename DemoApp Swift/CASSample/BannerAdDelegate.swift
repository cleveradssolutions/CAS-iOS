//
//  BannerAdDelegate.swift
//  CASSample
//
//  Copyright © 2022 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import UIKit

class BannerAdDelegate: CASBannerDelegate {
    var infoLabel: UILabel?

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        infoLabel?.text = "Ready"
        print("[CAS Sample] Banner Ad loaded and ready to present")
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        infoLabel?.text = error.message
        print("[CAS Sample] Banner Ad did fail: \(error.message)")
    }

    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        print("[CAS Sample] Banner Ad will present")
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        print("[CAS Sample] Banner Ad did record click")
    }
}
