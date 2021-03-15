//
//  SceneDelegate.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationDidBecomeActive
        if let rootController = window?.rootViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.tryToPresentAppOpenAd(rootController)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationWillResignActive
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationWillEnterForeground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationDidEnterBackground
    }
}
