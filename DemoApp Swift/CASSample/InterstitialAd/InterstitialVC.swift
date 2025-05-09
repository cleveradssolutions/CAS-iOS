//
//  InterstitialVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class InterstitialVC: UIViewController {
            
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var showButton: UIButton!
                
    private var interstitial = CASInterstitial(casID: AppDelegate.casId)
            
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial.delegate = self
        interstitial.impressionDelegate = self
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Interstitial Ad"
    }
    
    @IBAction private func loadAction(_ sender: UIButton) {
        interstitial.loadAd()
    }
    
    @IBAction private func showAction(_ sender: UIButton) {
        interstitial.present(from: self)
    }
}

extension InterstitialVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension InterstitialVC: CASScreenContentDelegate { 
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
