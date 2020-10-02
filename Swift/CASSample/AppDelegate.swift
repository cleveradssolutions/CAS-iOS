//
//  AppDelegate.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set any CAS Settings before CAS.create
        CAS.settings.setDebugMode(true)
        // CAS.settings.updateUser(consent: .accepted)
        // CAS.settings.updateCCPA(status: .optInSale)
        // CAS.settings.setTagged(audience: .notChildren)

        // CAS storage last created manager in strong static CAS.manager property
        let manager = CAS.create(managerID: "demo",
                                 enableTypes: [.banner, .interstitial, .rewarded],
                                 demoAdMode: true) { complete, error in
            print("[CAS Sample] Mediation manager initialization: \(complete) with error: \(String(describing: error))")
        }
        // Set banner size immediately after CAS.create
        manager.setBanner(size: .getSmartBanner())

        return true
    }
}
