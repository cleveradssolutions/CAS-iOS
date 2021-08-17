//
//  AppDelegate.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CASCallback {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Validate integration. For develop only.
        CAS.validateIntegration()
        
        configureCAS()
        let manager = createCASManager()

        // Set banner size immediately after CAS.create
        manager.setBanner(size: .getSmartBanner())

        return true
    }

    // MARK: Initialize Clever Ads Solutions

    func configureCAS() {
        // Set any CAS Settings before CAS.create
        CAS.settings.setDebugMode(true)
        // CAS.settings.updateUser(consent: .accepted)
        // CAS.settings.updateCCPA(status: .optInSale)
        // CAS.settings.setTagged(audience: .notChildren)
        CAS.settings.setTrackLocation(enabled: true)
        CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: true)

        // Inform SDK of the users details
        CAS.targetingOptions.setAge(12)
        CAS.targetingOptions.setGender(.female)
    }

    func createCASManager() -> CASMediationManager {
        // CAS storage last created manager in strong static CAS.manager property
        return CAS.create(managerID: "demo",
                          enableTypes: [.banner, .interstitial, .rewarded],
                          demoAdMode: true) { complete, error in
            print("[CAS Sample] Mediation manager initialization: \(complete) with error: \(String(describing: error))")
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
