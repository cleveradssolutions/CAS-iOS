//
//  FormatsSection.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import Foundation

enum FormatsSection: CaseIterable {
    case appOpen
    case banner
    case native
    case nativeTemplate
    case interstitial
    case rewarded
    
    var title: String {
        switch self {
        case .appOpen:
            return "App Open"
        case .banner:
            return "Banner"
        case .native:
            return "Native"
        case .nativeTemplate:
            return "Native Template"
        case .interstitial:
            return "Interstitial"
        case .rewarded:
            return "Rewarded"
        }
    }
}
