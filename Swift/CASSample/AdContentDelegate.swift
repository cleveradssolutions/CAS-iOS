//
//  AdDelegate.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import Foundation
import UIKit

class AdContentDelegate: CASCallback {
    let type: CASType
    var infoLabel: UILabel?

    init(type: CASType) {
        self.type = type
    }

    func willShown(ad adStatus: CASStatusHandler) {
        infoLabel?.text = adStatus.identifier
        print("[CAS Sample] \(type.description) Ad received Show action")
    }

    func didShowAdFailed(error: String) {
        print("[CAS Sample] \(type.description) Ad show failed: \(error)")
    }

    func didClickedAd() {
        print("[CAS Sample] \(type.description) Ad received Click action")
    }

    func didCompletedAd() {
        print("[CAS Sample] \(type.description) Ad complete. You have been rewarded")
    }

    func didClosedAd() {
        print("[CAS Sample] \(type.description) Ad received Close action")
    }
}
