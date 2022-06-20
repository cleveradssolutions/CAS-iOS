//
//  AppDelegate.swift
//  CASSample
//
//  Copyright © 2022 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CASCallback {
    var window: UIWindow?
    
    static var mediationManager: CASMediationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Validate integration. For develop only.
        CAS.validateIntegration()

        AppDelegate.configureCAS()
        AppDelegate.createCASManager()
        return true
    }

    // MARK: Initialize Clever Ads Solutions

    static func configureCAS() {
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

    static func createCASManager() {
        // CAS storage last created manager in strong static CAS.manager property
        mediationManager = CAS.buildManager()
            .withAdTypes(.banner, .interstitial, .rewarded)
            .withTestAdMode(true)
            .withCompletionHandler({ initialConfig in
                if let error = initialConfig.error {
                    print("[CAS Sample] Mediation manager initialization failed: \(error)")
                } else {
                    print("[CAS Sample] Mediation manager initialization complete.")
                }
            })
            .create(withCasId: "demo")
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
