//
//  AppCoordinator.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class AppCoordinator {
    
    private let window: UIWindow
    private let storyboard: UIStoryboard
    
    private var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
    }

    func start() {
        let mainVC = instantiateMainMenuViewController()
        navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func instantiateMainMenuViewController() -> MainVC {
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.coordinator = self
        return vc
    }
    
    func navigateToBannerAd() {
        let vc = storyboard.instantiateViewController(withIdentifier: "BannerVC") as! BannerVC
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToNativeAd() {
        let vc = storyboard.instantiateViewController(withIdentifier: "NativeVC") as! NativeVC
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToNativeTemplate() {
        let vc = storyboard.instantiateViewController(withIdentifier: "NativeTemplateVC") as! NativeTemplateVC
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToInterstitialAd() {       
        let vc = storyboard.instantiateViewController(withIdentifier: "InterstitialVC") as! InterstitialVC
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToRewardedAd() {
        let vc = storyboard.instantiateViewController(withIdentifier: "RewardedVC") as! RewardedVC
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAppOpenAd() {
        let vc = storyboard.instantiateViewController(withIdentifier: "AppOpenVC") as! AppOpenVC        
        navigationController.pushViewController(vc, animated: true)
    }
       
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
