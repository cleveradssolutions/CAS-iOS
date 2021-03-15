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
    var window: UIWindow?
    var appOpenAd: CASAppOpen!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Validate integration. For develop only.
        CAS.validateIntegration()
        
        configureCAS()
        let manager = createCASManager()

        // Set banner size immediately after CAS.create
        manager.setBanner(size: .getSmartBanner())

        createAppOpenAd(manager)
        requestAppOpenAd()

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

    // MARK: AppOpenAd implementation

    func createAppOpenAd(_ manager:CASMediationManager){
        appOpenAd = CASAppOpen.create(manager: manager)
        appOpenAd.contentCallback = self
    }
    
    func requestAppOpenAd() {
        appOpenAd.loadAd(orientation: UIInterfaceOrientation.portrait,
                         completionHandler: { _, error in
                             if let error = error {
                                 print("[CAS Sample] App Open Ad failed to load: " + error.localizedDescription)
                             } else {
                                 print("[CAS Sample] App Open Ad loaded")
                             }
                         })
    }

    func tryToPresentAppOpenAd(_ rootController: UIViewController) {
        // If App Open Ad not ready then tells the delegate didShowAdFailed(error:)
        appOpenAd.present(fromRootViewController: rootController)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // If you use Scenes, call tryToPresentAppOpenAd in the sceneDidBecomeActive: method of your UISceneDelegate instead.
        if let rootController = window?.rootViewController {
            tryToPresentAppOpenAd(rootController)
        }
    }

    // MARK: AppOpenAd content callback

    func willShown(ad adStatus: CASStatusHandler) {
        print("[CAS Sample] App Open Ad will presented")
    }

    func didShowAdFailed(error: String) {
        print("[CAS Sample] App Open Ad failed to present with error: " + error)
        requestAppOpenAd()
    }

    func didClosedAd() {
        print("[CAS Sample] App Open Ad did closed")
        requestAppOpenAd()
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
