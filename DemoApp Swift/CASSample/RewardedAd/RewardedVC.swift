//
//  RewardedVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class RewardedVC: UIViewController {
    
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var showButton: UIButton!
    
    private var rewarded = CASRewarded(casID: AppDelegate.casId)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        rewarded.delegate = self
        rewarded.impressionDelegate = self
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Rewarded Ad"
    }
    
    @IBAction private func loadAction(_ sender: UIButton) {
        rewarded.loadAd()
    }
    
    @IBAction private func showAction(_ sender: UIButton) {
        rewarded.present(from: self, userDidEarnRewardHandler: { _ in
            print(#function, "Reward earned")
        })
    }
}

extension RewardedVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension RewardedVC: CASScreenContentDelegate {
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
