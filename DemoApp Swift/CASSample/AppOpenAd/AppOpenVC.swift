//
//  AppOpenVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class AppOpenVC: UIViewController {
                    
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var showButton: UIButton!
            
    private var appOpen = CASAppOpen(casID: AppDelegate.casId)

    override func viewDidLoad() {
        super.viewDidLoad()
        appOpen.delegate = self
        appOpen.impressionDelegate = self
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "App Open Ad"
    }
    
    @IBAction private func loadAction(_ sender: UIButton) {
        appOpen.loadAd()
    }
    
    @IBAction private func showAction(_ sender: UIButton) {
        appOpen.present(from: self)
    }
}

extension AppOpenVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension AppOpenVC: CASScreenContentDelegate {
    func screenAdDidLoadContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAd(_ ad: any CASScreenContent, didFailToLoadWithError error: AdError) {
        print(#function, "Error: \(error.description)")
    }
    
    func screenAdWillPresentContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAd(_ ad: any CASScreenContent, didFailToPresentWithError error: AdError) {
        print(#function, "Error: \(error.description)")
    }
    
    func screenAdDidClickContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAdDidDismissContent(_ ad: any CASScreenContent) {
        print(#function)
    }
}
