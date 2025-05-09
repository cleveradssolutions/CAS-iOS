//
//  AppDelegate.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let casId = "demo"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeCAS()
        return true
    }

    func initializeCAS() {
        // Configure CAS.settings before initialize
        // Configure CAS.targetingOptions before initialize

        let builder = CAS.buildManager()
        builder.withCompletionHandler { config in
            // The CAS SDK initializes if the error is `nil`
            let error: String? = config.error
            let userCountryISO2: String? = config.countryCode

            // True if the user is protected by GDPR or other regulations
            let protectionApplied: Bool = config.isConsentRequired

            // The user completes the consent flow
            let consentStatus = config.consentFlowStatus
            let trackingAuthorized: Bool = config.isATTrackingAuthorized
        }
        #if DEBUG
            builder.withTestAdMode(true)
        #endif

        builder.create(withCasId: AppDelegate.casId)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
